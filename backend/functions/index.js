const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
const crypto = require('crypto');
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { RateLimiterMemory } = require('rate-limiter-flexible');

// Initialize Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const auth = admin.auth();

// Rate limiter configuration
const otpRateLimiter = new RateLimiterMemory({
  keyGenerator: (req) => req.body.phoneNumber || req.ip,
  points: 3, // Number of requests
  duration: 3600, // Per hour
});

const verificationRateLimiter = new RateLimiterMemory({
  keyGenerator: (req) => req.body.phoneNumber || req.ip,
  points: 5, // Number of attempts
  duration: 300, // Per 5 minutes
});

// Text.lk SMS Gateway Configuration
const SMS_CONFIG = {
  apiUrl: 'https://api.text.lk/sms/send',
  userId: functions.config().textlk?.userid || process.env.TEXTLK_USER_ID,
  apiKey: functions.config().textlk?.apikey || process.env.TEXTLK_API_KEY,
  senderId: functions.config().textlk?.senderid || process.env.TEXTLK_SENDER_ID || 'SafeDriver',
};

// Utility functions
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

function hashOTP(otp) {
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
    const response = await axios.post(SMS_CONFIG.apiUrl, {
      user_id: SMS_CONFIG.userId,
      api_key: SMS_CONFIG.apiKey,
      sender_id: SMS_CONFIG.senderId,
      to: phoneNumber.replace('+', ''),
      message: message,
    }, {
      headers: {
        'Content-Type': 'application/json',
      },
      timeout: 10000,
    });

    return {
      success: response.data.status === 'success',
      response: response.data,
      messageId: response.data.message_id,
    };
  } catch (error) {
    console.error('SMS sending failed:', error.response?.data || error.message);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send SMS',
      error.response?.data || error.message
    );
  }
}

// Cloud Function: Send OTP
exports.sendOTP = functions
  .region('asia-south1') // Choose closest region to Sri Lanka
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
        new Date(Date.now() + 10 * 60 * 1000) // 10 minutes from now
      );

      // Store verification record in Firestore
      await db.collection('otp_verifications').doc(verificationId).set({
        phoneNumber: formattedPhone,
        hashedOTP,
        attempts: 0,
        maxAttempts: 3,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt,
        status: 'pending',
        ipAddress: context.rawRequest?.ip,
        userAgent: context.rawRequest?.get('user-agent'),
      });

      // Prepare SMS message
      const message = `Your SafeDriver verification code is: ${otp}. Valid for 10 minutes. Do not share this code with anyone.`;

      // Send SMS
      const smsResult = await sendSMS(formattedPhone, message);
      
      // Update verification record with SMS status
      await db.collection('otp_verifications').doc(verificationId).update({
        smsStatus: smsResult.success ? 'sent' : 'failed',
        smsMessageId: smsResult.messageId,
        smsResponse: smsResult.response,
      });

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
      
      // Generate custom token for client authentication
      customToken = await auth.createCustomToken(userId, {
        phoneVerified: true,
        verificationId,
      });
      
      console.log(`OTP verified successfully for ${formattedPhone}, userId: ${userId}`);
      
      return {
        success: true,
        customToken,
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