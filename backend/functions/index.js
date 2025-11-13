const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');
const axios = require('axios');
const crypto = require('crypto');
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { RateLimiterMemory } = require('rate-limiter-flexible');

// Load environment variables (only in local development)
try {
    require('dotenv').config();
} catch (error) {
    console.log('dotenv not loaded, using environment variables');
}

// Initialize Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const auth = admin.auth();

// Environment configuration with fallbacks
const config = {
    textlk: {
        apiToken: process.env.TEXTLK_API_TOKEN || functions.config().textlk?.apitoken,
        apiUrl: process.env.TEXTLK_API_URL || 'https://app.text.lk/api/v3/sms/send',
        senderId: process.env.TEXTLK_SENDER_ID || functions.config().textlk?.senderid || 'SafeDriver',
    },
    otp: {
        expiryMinutes: parseInt(process.env.OTP_EXPIRY_MINUTES) || 10,
        maxAttempts: parseInt(process.env.OTP_MAX_ATTEMPTS) || 3,
        length: parseInt(process.env.OTP_LENGTH) || 6,
    },
    rateLimits: {
        otpPoints: parseInt(process.env.OTP_RATE_LIMIT_POINTS) || 3,
        otpDuration: parseInt(process.env.OTP_RATE_LIMIT_DURATION) || 3600,
        verificationPoints: parseInt(process.env.VERIFICATION_RATE_LIMIT_POINTS) || 5,
        verificationDuration: parseInt(process.env.VERIFICATION_RATE_LIMIT_DURATION) || 300,
    },
    firebase: {
        projectId: process.env.PROJECT_ID || 'safe-driver-system',
        region: process.env.REGION || 'asia-south1',
    },
    debug: process.env.DEBUG_MODE === 'true' || false,
};

// Rate limiter configuration
const otpRateLimiter = new RateLimiterMemory({
    keyGenerator: (req) => req.body.phoneNumber || req.ip,
    points: config.rateLimits.otpPoints,
    duration: config.rateLimits.otpDuration,
});

const verificationRateLimiter = new RateLimiterMemory({
    keyGenerator: (req) => req.body.phoneNumber || req.ip,
    points: config.rateLimits.verificationPoints,
    duration: config.rateLimits.verificationDuration,
});

// Utility functions
function generateOTP() {
    const otpLength = config.otp.length;
    const min = Math.pow(10, otpLength - 1);
    const max = Math.pow(10, otpLength) - 1;
    return Math.floor(min + Math.random() * (max - min + 1)).toString();
}

function formatSMSMessage(otp) {
    const template = process.env.SMS_TEMPLATE ||
        'Your SafeDriver verification code is: {OTP}. Valid for {MINUTES} minutes. Do not share this code with anyone.';

    return template
        .replace('{OTP}', otp)
        .replace('{MINUTES}', config.otp.expiryMinutes.toString());
} function hashOTP(otp) {
    return crypto.createHash('sha256').update(otp).digest('hex');
}

function formatPhoneNumber(phoneNumber) {
    // Ensure Sri Lankan phone number format (+94XXXXXXXXX)
    let cleaned = phoneNumber.replace(/\D/g, '');

    if (cleaned.startsWith('0')) {
        cleaned = '94' + cleaned.substring(1);
    } else if (cleaned.startsWith('94')) {
        cleaned = cleaned;
    } else if (cleaned.length === 9) {
        cleaned = '94' + cleaned;
    }

    return '+' + cleaned;
}

function validateSriLankanPhoneNumber(phoneNumber) {
    const formatted = formatPhoneNumber(phoneNumber);
    const regex = /^\+94[1-9]\d{8}$/;
    return regex.test(formatted);
}

async function sendSMS(phoneNumber, message) {
    try {
        if (config.debug) {
            console.log(`Sending SMS to ${phoneNumber} via Text.lk API v3`);
        }

        // Text.lk API v3 request format
        const requestData = {
            recipient: phoneNumber.replace('+', ''),
            message: message,
            sender_id: config.textlk.senderId,
        };

        const response = await axios.post(config.textlk.apiUrl, requestData, {
            headers: {
                'Authorization': `Bearer ${config.textlk.apiToken}`,
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            },
            timeout: 15000, // Increased timeout for API v3
        });

        if (config.debug) {
            console.log('Text.lk API Response:', response.data);
        }

        // Text.lk API v3 response format
        const isSuccess = response.status === 200 && response.data.status === 'success';

        return {
            success: isSuccess,
            response: response.data,
            messageId: response.data.data?.message_id || response.data.message_id,
            status: response.data.status,
            message: response.data.message,
        };
    } catch (error) {
        console.error('SMS sending failed:', {
            error: error.message,
            response: error.response?.data,
            status: error.response?.status,
            phoneNumber: phoneNumber,
        });

        throw new functions.https.HttpsError(
            'internal',
            'Failed to send SMS via Text.lk',
            {
                error: error.message,
                apiResponse: error.response?.data,
                phoneNumber: phoneNumber,
            }
        );
    }
}// Cloud Function: Send OTP
exports.sendOTP = functions
    .region('asia-south1')
    .https.onCall(async (data, context) => {
        try {
            // Validate input
            const { phoneNumber } = data;

            if (!phoneNumber) {
                throw new functions.https.HttpsError(
                    'invalid-argument',
                    'Phone number is required'
                );
            }

            // Format and validate phone number
            const formattedPhone = formatPhoneNumber(phoneNumber);
            if (!validateSriLankanPhoneNumber(formattedPhone)) {
                throw new functions.https.HttpsError(
                    'invalid-argument',
                    'Invalid Sri Lankan phone number format'
                );
            }

            // Rate limiting
            try {
                await otpRateLimiter.consume(formattedPhone);
            } catch (rejRes) {
                throw new functions.https.HttpsError(
                    'resource-exhausted',
                    `Too many OTP requests. Try again in ${Math.round(rejRes.msBeforeNext / 1000 / 60)} minutes`
                );
            }

            // Generate OTP and verification ID
            const otp = generateOTP();
            const verificationId = crypto.randomUUID();
            const hashedOTP = hashOTP(otp);
            const expiresAt = admin.firestore.Timestamp.fromDate(
                new Date(Date.now() + config.otp.expiryMinutes * 60 * 1000)
            );            // Store verification record in Firestore
            await db.collection('otp_verifications').doc(verificationId).set({
                phoneNumber: formattedPhone,
                hashedOTP,
                attempts: 0,
                maxAttempts: config.otp.maxAttempts,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                expiresAt,
                status: 'pending',
                ipAddress: context.rawRequest?.ip,
                userAgent: context.rawRequest?.get('user-agent'),
            });

            // Prepare SMS message using template
            const message = formatSMSMessage(otp);            // Send SMS
            const smsResult = await sendSMS(formattedPhone, message);

            // Update verification record with SMS status
            const updateData = {
                smsStatus: smsResult.success ? 'sent' : 'failed',
                smsResponse: smsResult.response,
            };

            // Only add messageId if it exists
            if (smsResult.messageId) {
                updateData.smsMessageId = smsResult.messageId;
            }

            await db.collection('otp_verifications').doc(verificationId).update(updateData);

            if (!smsResult.success) {
                throw new functions.https.HttpsError(
                    'internal',
                    'Failed to send SMS verification code'
                );
            }

            console.log(`OTP sent successfully to ${formattedPhone}, verificationId: ${verificationId}`);

            return {
                success: true,
                verificationId,
                phoneNumber: formattedPhone,
                expiresAt: expiresAt.toDate().toISOString(),
            };
        } catch (error) {
            console.error('SendOTP error:', error);

            if (error instanceof functions.https.HttpsError) {
                throw error;
            }

            throw new functions.https.HttpsError(
                'internal',
                'An unexpected error occurred while sending OTP'
            );
        }
    });

// Cloud Function: Verify OTP
exports.verifyOTP = functions
    .region('asia-south1')
    .https.onCall(async (data, context) => {
        try {
            const { verificationId, otp, phoneNumber } = data;

            if (!verificationId || !otp) {
                throw new functions.https.HttpsError(
                    'invalid-argument',
                    'Verification ID and OTP are required'
                );
            }

            const formattedPhone = formatPhoneNumber(phoneNumber);

            // Rate limiting for verification attempts
            try {
                await verificationRateLimiter.consume(formattedPhone);
            } catch (rejRes) {
                throw new functions.https.HttpsError(
                    'resource-exhausted',
                    'Too many verification attempts. Please try again later.'
                );
            }

            // Get verification record
            const verificationDoc = await db.collection('otp_verifications').doc(verificationId).get();

            if (!verificationDoc.exists) {
                throw new functions.https.HttpsError(
                    'not-found',
                    'Invalid verification ID'
                );
            }

            const verificationData = verificationDoc.data();

            // Check if already verified
            if (verificationData.status === 'verified') {
                throw new functions.https.HttpsError(
                    'failed-precondition',
                    'OTP has already been verified'
                );
            }

            // Check if expired
            if (verificationData.expiresAt.toDate() < new Date()) {
                await verificationDoc.ref.update({
                    status: 'expired',
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
                throw new functions.https.HttpsError(
                    'deadline-exceeded',
                    'OTP has expired. Please request a new one.'
                );
            }

            // Check attempts
            if (verificationData.attempts >= verificationData.maxAttempts) {
                await verificationDoc.ref.update({
                    status: 'failed',
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
                throw new functions.https.HttpsError(
                    'resource-exhausted',
                    'Maximum verification attempts exceeded. Please request a new OTP.'
                );
            }

            // Verify OTP
            const hashedInputOTP = hashOTP(otp);
            const isValidOTP = hashedInputOTP === verificationData.hashedOTP;

            if (!isValidOTP) {
                // Increment attempts
                await verificationDoc.ref.update({
                    attempts: admin.firestore.FieldValue.increment(1),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });

                throw new functions.https.HttpsError(
                    'invalid-argument',
                    'Invalid OTP. Please try again.'
                );
            }

            // OTP is valid - mark as verified
            await verificationDoc.ref.update({
                status: 'verified',
                verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            // Create or update Firebase Auth user
            let customToken;
            let userId;

            try {
                // Try to get existing user by phone number
                const userRecord = await auth.getUserByPhoneNumber(formattedPhone);
                userId = userRecord.uid;

                // Update last login
                await auth.setCustomUserClaims(userId, {
                    phoneVerified: true,
                    lastLogin: Date.now(),
                });

            } catch (error) {
                if (error.code === 'auth/user-not-found') {
                    // Create new user
                    const newUser = await auth.createUser({
                        phoneNumber: formattedPhone,
                        emailVerified: false,
                        disabled: false,
                    });

                    userId = newUser.uid;

                    // Set custom claims
                    await auth.setCustomUserClaims(userId, {
                        phoneVerified: true,
                        lastLogin: Date.now(),
                    });

                    // Create user profile in Firestore
                    await db.collection('users').doc(userId).set({
                        phoneNumber: formattedPhone,
                        isVerified: true,
                        isActive: true,
                        createdAt: admin.firestore.FieldValue.serverTimestamp(),
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                        authMethod: 'phone',
                        preferences: {
                            language: 'en',
                            theme: 'system',
                            notifications: {
                                safetyAlerts: true,
                                journeyUpdates: true,
                                emergencyAlerts: true,
                                systemAnnouncements: true,
                            },
                        },
                        stats: {
                            todayTrips: 0,
                            totalTrips: 0,
                            carbonSaved: 0.0,
                            pointsEarned: 0,
                            safetyScore: 5.0,
                        },
                    });
                } else {
                    throw error;
                }
            }

            // Instead of custom token, we'll use Firebase Auth to verify and authenticate
            // Update user claims to mark phone as verified
            await auth.setCustomUserClaims(userId, {
                phoneVerified: true,
                verificationId,
                verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            console.log(`OTP verified successfully for ${formattedPhone}, userId: ${userId}`);

            return {
                success: true,
                message: 'Phone number verified successfully',
                userId,
                userId,
                phoneNumber: formattedPhone,
                isNewUser: !userRecord,
            };

        } catch (error) {
            console.error('VerifyOTP error:', error);

            if (error instanceof functions.https.HttpsError) {
                throw error;
            }

            throw new functions.https.HttpsError(
                'internal',
                'An unexpected error occurred during verification'
            );
        }
    });

// Cloud Function: Cleanup expired OTP records
exports.cleanupExpiredOTPs = functions
    .region('asia-south1')
    .pubsub.schedule('every 1 hours')
    .onRun(async (context) => {
        const now = admin.firestore.Timestamp.now();
        const expiredQuery = db.collection('otp_verifications')
            .where('expiresAt', '<', now)
            .limit(100);

        const expiredDocs = await expiredQuery.get();

        if (expiredDocs.empty) {
            console.log('No expired OTP records to clean up');
            return null;
        }

        const batch = db.batch();
        expiredDocs.forEach(doc => {
            batch.delete(doc.ref);
        });

        await batch.commit();
        console.log(`Cleaned up ${expiredDocs.size} expired OTP records`);

        return null;
    });

// Health check endpoint
exports.healthCheck = functions
    .region('asia-south1')
    .https.onRequest((req, res) => {
        res.json({
            status: 'healthy',
            timestamp: new Date().toISOString(),
            region: 'asia-south1',
            service: 'safe-driver-sms-gateway',
        });
    });