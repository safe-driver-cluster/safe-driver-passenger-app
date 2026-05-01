const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');
const axios = require('axios');

// Initialize Firebase Admin (if not already done in main index.js)
if (admin.apps.length === 0) {
    admin.initializeApp();
}

const db = admin.firestore();
const messaging = admin.messaging();

// Configuration
const config = {
    notificationChannels: {
        registration: 'registration',
        login: 'login_welcome',
        feedback: 'feedback_updates',
        profile: 'profile_updates',
        journey: 'journey_notifications',
    },
    debug: process.env.DEBUG_MODE === 'true' || false,
};

// ============================================================================
// 1. REGISTRATION NOTIFICATION - Account Created Successfully
// ============================================================================
exports.sendRegistrationNotification = functions.auth.user().onCreate(
    async (user) => {
        console.log(`Registration notification triggered for user: ${user.uid}`);

        try {
            // Get user email first name from additional claims or email
            const email = user.email || 'User';
            const firstName = email.split('@')[0]; // Use part before @ as fallback

            // Get user's device tokens for push notifications
            const userDoc = await db.collection('passenger_details').doc(user.uid).get();

            const notification = {
                userId: user.uid,
                type: 'registration',
                title: '🎉 Welcome to SafeDriver!',
                body: 'Your account has been created successfully. Start exploring safest routes!',
                imageUrl: null,
                priority: 'high',
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
                data: {
                    firstName: firstName,
                    email: user.email,
                    createdAt: new Date().toISOString(),
                    actionUrl: '/profile',
                },
            };

            // Store notification in Firestore
            const notifRef = await db.collection('notifications').add(notification);
            console.log(`Registration notification stored: ${notifRef.id}`);

            // Send FCM push notification if device tokens exist
            if (userDoc.exists && userDoc.data().deviceTokens && userDoc.data().deviceTokens.length > 0) {
                const deviceTokens = userDoc.data().deviceTokens;
                await sendPushNotification(
                    deviceTokens,
                    notification.title,
                    notification.body,
                    {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        actionUrl: '/profile',
                        notificationType: 'registration',
                    }
                );
                console.log(`FCM push notification sent to ${deviceTokens.length} devices`);
            }

            return { success: true, notificationId: notifRef.id };
        } catch (error) {
            console.error('Error sending registration notification:', error);
            // Don't throw - user registration should not fail due to notification issues
            return { success: false, error: error.message };
        }
    }
);

// ============================================================================
// 2. LOGIN WELCOME NOTIFICATION - First Time Login
// ============================================================================
exports.sendLoginWelcomeNotification = functions.https.onCall(async (data, context) => {
    console.log('Login welcome notification triggered');

    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
    }

    try {
        const userId = context.auth.uid;
        const firstName = data.firstName || 'Traveler';

        // Check if this is user's first login
        const userDoc = await db.collection('passenger_details').doc(userId).get();
        const isFirstLogin = !userDoc.data()?.lastLoginAt;

        if (isFirstLogin) {
            const notification = {
                userId: userId,
                type: 'login',
                title: '👋 Welcome Back!',
                body: `Hello ${firstName}! Ready to explore safe routes? Check out our latest features.`,
                imageUrl: null,
                priority: 'normal',
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
                data: {
                    firstName: firstName,
                    isFirstLogin: true,
                    actionUrl: '/dashboard',
                },
            };

            // Store notification in Firestore
            const notifRef = await db.collection('notifications').add(notification);
            console.log(`Login welcome notification stored: ${notifRef.id}`);

            // Send FCM push notification
            const deviceTokens = userDoc.data()?.deviceTokens || [];
            if (deviceTokens.length > 0) {
                await sendPushNotification(
                    deviceTokens,
                    notification.title,
                    notification.body,
                    {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        actionUrl: '/dashboard',
                        notificationType: 'login',
                    }
                );
            }

            return { success: true, notificationId: notifRef.id };
        } else {
            console.log('Not first login, skipping welcome notification');
            return { success: false, message: 'Not first login' };
        }
    } catch (error) {
        console.error('Error sending login welcome notification:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});

// ============================================================================
// 3. FEEDBACK SUBMISSION NOTIFICATION
// ============================================================================
exports.sendFeedbackNotification = functions.firestore
    .document('feedbacks/{feedbackId}')
    .onCreate(async (snap, context) => {
        console.log('Feedback submission notification triggered');

        try {
            const feedback = snap.data();
            const userId = feedback.userId;
            const userDoc = await db.collection('passenger_details').doc(userId).get();

            const notification = {
                userId: userId,
                type: 'feedback',
                title: '💬 Feedback Received',
                body: `Thank you for your feedback! We've received your ${feedback.category || 'feedback'} and will review it shortly.`,
                imageUrl: null,
                priority: 'normal',
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
                data: {
                    feedbackId: context.params.feedbackId,
                    category: feedback.category || 'general',
                    actionUrl: '/feedbacks',
                },
            };

            // Store notification
            const notifRef = await db.collection('notifications').add(notification);
            console.log(`Feedback notification stored: ${notifRef.id}`);

            // Send FCM
            const deviceTokens = userDoc.data()?.deviceTokens || [];
            if (deviceTokens.length > 0) {
                await sendPushNotification(
                    deviceTokens,
                    notification.title,
                    notification.body,
                    {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        actionUrl: '/feedbacks',
                        notificationType: 'feedback',
                        feedbackId: context.params.feedbackId,
                    }
                );
            }

            return { success: true, notificationId: notifRef.id };
        } catch (error) {
            console.error('Error sending feedback notification:', error);
            return { success: false, error: error.message };
        }
    });

// ============================================================================
// 4. FEEDBACK STATUS UPDATE NOTIFICATION
// ============================================================================
exports.sendFeedbackStatusNotification = functions.firestore
    .document('feedbacks/{feedbackId}')
    .onUpdate(async (change, context) => {
        console.log('Feedback status update notification triggered');

        try {
            const beforeData = change.before.data();
            const afterData = change.after.data();

            // Check if status changed
            if (beforeData.status === afterData.status) {
                console.log('Status did not change, skipping notification');
                return { success: false, message: 'Status unchanged' };
            }

            const userId = afterData.userId;
            const userDoc = await db.collection('passenger_details').doc(userId).get();

            const statusMessages = {
                'pending': 'Your feedback is being reviewed',
                'in_review': 'Your feedback is under review',
                'resolved': 'Your feedback has been resolved',
                'rejected': 'Your feedback could not be addressed',
            };

            const notification = {
                userId: userId,
                type: 'feedbackStatus',
                title: '📝 Feedback Status Update',
                body: statusMessages[afterData.status] || 'Your feedback status has been updated',
                imageUrl: null,
                priority: afterData.status === 'resolved' ? 'high' : 'normal',
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
                data: {
                    feedbackId: context.params.feedbackId,
                    previousStatus: beforeData.status,
                    newStatus: afterData.status,
                    actionUrl: '/feedbacks',
                },
            };

            // Store notification
            const notifRef = await db.collection('notifications').add(notification);
            console.log(`Feedback status notification stored: ${notifRef.id}`);

            // Send FCM
            const deviceTokens = userDoc.data()?.deviceTokens || [];
            if (deviceTokens.length > 0) {
                await sendPushNotification(
                    deviceTokens,
                    notification.title,
                    notification.body,
                    {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        actionUrl: '/feedbacks',
                        notificationType: 'feedbackStatus',
                        newStatus: afterData.status,
                    }
                );
            }

            return { success: true, notificationId: notifRef.id };
        } catch (error) {
            console.error('Error sending feedback status notification:', error);
            return { success: false, error: error.message };
        }
    });

// ============================================================================
// 5. PROFILE UPDATE NOTIFICATION
// ============================================================================
exports.sendProfileUpdateNotification = functions.firestore
    .document('passenger_details/{userId}')
    .onUpdate(async (change, context) => {
        console.log('Profile update notification triggered');

        try {
            const beforeData = change.before.data();
            const afterData = change.after.data();
            const userId = context.params.userId;

            // Determine what was updated
            const updates = [];
            if (beforeData.firstName !== afterData.firstName || beforeData.lastName !== afterData.lastName) {
                updates.push('name');
            }
            if (beforeData.phoneNumber !== afterData.phoneNumber) {
                updates.push('phone number');
            }
            if (beforeData.profileImageUrl !== afterData.profileImageUrl) {
                updates.push('profile image');
            }
            if (beforeData.address !== afterData.address) {
                updates.push('address');
            }

            if (updates.length === 0) {
                console.log('No significant profile changes detected');
                return { success: false, message: 'No profile updates' };
            }

            const notification = {
                userId: userId,
                type: 'profile',
                title: '👤 Profile Updated',
                body: `Your profile has been updated (${updates.join(', ')})`,
                imageUrl: null,
                priority: 'normal',
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
                data: {
                    updatedFields: updates,
                    actionUrl: '/profile',
                },
            };

            // Store notification
            const notifRef = await db.collection('notifications').add(notification);
            console.log(`Profile update notification stored: ${notifRef.id}`);

            // Send FCM
            const deviceTokens = afterData.deviceTokens || [];
            if (deviceTokens.length > 0) {
                await sendPushNotification(
                    deviceTokens,
                    notification.title,
                    notification.body,
                    {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        actionUrl: '/profile',
                        notificationType: 'profile',
                        updatedFields: updates.join(','),
                    }
                );
            }

            return { success: true, notificationId: notifRef.id };
        } catch (error) {
            console.error('Error sending profile update notification:', error);
            return { success: false, error: error.message };
        }
    });

// ============================================================================
// 6. ACTIVE JOURNEY NOTIFICATIONS
// ============================================================================
exports.sendJourneyStartedNotification = functions.https.onCall(async (data, context) => {
    console.log('Journey started notification triggered');

    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
    }

    try {
        const { journeyId, busNumber, destination, departureTime } = data;
        const userId = context.auth.uid;
        const userDoc = await db.collection('passenger_details').doc(userId).get();

        const notification = {
            userId: userId,
            type: 'journey',
            title: '🚌 Journey Started',
            body: `Your journey on bus ${busNumber} to ${destination} has started. Safe travels!`,
            imageUrl: null,
            priority: 'high',
            status: 'sent',
            sentAt: admin.firestore.Timestamp.now(),
            isSilent: false,
            data: {
                journeyId: journeyId,
                busNumber: busNumber,
                destination: destination,
                departureTime: departureTime,
                actionUrl: '/journey-tracking',
            },
        };

        // Store notification
        const notifRef = await db.collection('notifications').add(notification);
        console.log(`Journey started notification stored: ${notifRef.id}`);

        // Send FCM
        const deviceTokens = userDoc.data()?.deviceTokens || [];
        if (deviceTokens.length > 0) {
            await sendPushNotification(
                deviceTokens,
                notification.title,
                notification.body,
                {
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    actionUrl: '/journey-tracking',
                    notificationType: 'journey',
                    journeyId: journeyId,
                }
            );
        }

        return { success: true, notificationId: notifRef.id };
    } catch (error) {
        console.error('Error sending journey started notification:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});

exports.sendJourneyCompletedNotification = functions.https.onCall(async (data, context) => {
    console.log('Journey completed notification triggered');

    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
    }

    try {
        const { journeyId, busNumber, destination, duration } = data;
        const userId = context.auth.uid;
        const userDoc = await db.collection('passenger_details').doc(userId).get();

        const notification = {
            userId: userId,
            type: 'journey',
            title: '✅ Journey Completed',
            body: `Your journey on bus ${busNumber} to ${destination} completed in ${duration}. Thank you for choosing SafeDriver!`,
            imageUrl: null,
            priority: 'normal',
            status: 'sent',
            sentAt: admin.firestore.Timestamp.now(),
            isSilent: false,
            data: {
                journeyId: journeyId,
                busNumber: busNumber,
                destination: destination,
                duration: duration,
                actionUrl: '/journeys-history',
            },
        };

        // Store notification
        const notifRef = await db.collection('notifications').add(notification);
        console.log(`Journey completed notification stored: ${notifRef.id}`);

        // Send FCM
        const deviceTokens = userDoc.data()?.deviceTokens || [];
        if (deviceTokens.length > 0) {
            await sendPushNotification(
                deviceTokens,
                notification.title,
                notification.body,
                {
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    actionUrl: '/journeys-history',
                    notificationType: 'journey',
                    journeyId: journeyId,
                }
            );
        }

        return { success: true, notificationId: notifRef.id };
    } catch (error) {
        console.error('Error sending journey completed notification:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});

// ============================================================================
// HELPER FUNCTION: Send FCM Push Notification
// ============================================================================
async function sendPushNotification(deviceTokens, title, body, data) {
    try {
        const message = {
            notification: {
                title: title,
                body: body,
            },
            data: data,
            android: {
                priority: 'high',
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
            },
            apns: {
                headers: {
                    'apns-priority': '10',
                },
                payload: {
                    aps: {
                        alert: {
                            title: title,
                            body: body,
                        },
                        sound: 'default',
                        badge: 1,
                    },
                },
            },
            webpush: {
                notification: {
                    title: title,
                    body: body,
                    icon: '/icons/notification-icon.png',
                },
            },
        };

        // Send to multiple devices
        for (const token of deviceTokens) {
            try {
                await messaging.send({
                    ...message,
                    token: token,
                });
            } catch (error) {
                if (error.code === 'messaging/invalid-registration-token') {
                    console.log(`Invalid token: ${token}, removing...`);
                    // You can optionally remove invalid tokens
                } else {
                    console.error(`Error sending to token ${token}:`, error);
                }
            }
        }

        console.log(`Push notifications sent to ${deviceTokens.length} devices`);
        return true;
    } catch (error) {
        console.error('Error sending push notifications:', error);
        throw error;
    }
}

// ============================================================================
// HELPER FUNCTION: Send to Multiple Users
// ============================================================================
exports.sendBulkNotification = functions.https.onCall(async (data, context) => {
    // Verify admin access
    if (!context.auth || !context.auth.token.admin) {
        throw new functions.https.HttpsError('permission-denied', 'Admin access required');
    }

    try {
        const { userIds, title, body, type = 'general', priority = 'normal' } = data;

        const batch = db.batch();
        const results = [];

        for (const userId of userIds) {
            const notification = {
                userId: userId,
                type: type,
                title: title,
                body: body,
                imageUrl: null,
                priority: priority,
                status: 'sent',
                sentAt: admin.firestore.Timestamp.now(),
                isSilent: false,
            };

            const notifRef = db.collection('notifications').doc();
            batch.set(notifRef, notification);
            results.push(notifRef.id);
        }

        await batch.commit();
        console.log(`Bulk notifications sent to ${userIds.length} users`);
        return { success: true, notificationIds: results };
    } catch (error) {
        console.error('Error sending bulk notifications:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});
