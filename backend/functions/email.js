const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

if (admin.apps.length === 0) {
    admin.initializeApp();
}

const db = admin.firestore();
const region = 'asia-south1';

const emailConfig = {
    host: process.env.EMAIL_HOST,
    port: parseInt(process.env.EMAIL_PORT || '587', 10),
    secure: (process.env.EMAIL_SECURE || 'false') === 'true',
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
    fromName: process.env.EMAIL_FROM_NAME || 'SafeDriver',
    fromEmail:
        process.env.EMAIL_FROM_EMAIL ||
        process.env.EMAIL_USER,
    replyTo:
        process.env.EMAIL_REPLY_TO ||
        process.env.EMAIL_FROM_EMAIL ||
        process.env.EMAIL_USER,
    adminEmail:
        process.env.EMAIL_ADMIN ||
        process.env.EMAIL_REPLY_TO ||
        process.env.EMAIL_USER,
};

let transporter;

function hasEmailConfiguration() {
    return Boolean(emailConfig.host && emailConfig.user && emailConfig.pass && emailConfig.fromEmail);
}

function getTransporter() {
    if (!hasEmailConfiguration()) {
        throw new Error('Email service is not configured. Set Firebase Functions email config first.');
    }

    if (!transporter) {
        transporter = nodemailer.createTransport({
            host: emailConfig.host,
            port: emailConfig.port,
            secure: emailConfig.secure,
            auth: {
                user: emailConfig.user,
                pass: emailConfig.pass,
            },
        });
    }

    return transporter;
}

function escapeHtml(value) {
    return String(value ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function escapeAttribute(value) {
    return escapeHtml(value).replace(/`/g, '&#96;');
}

function normalizeText(value, fallback = 'Not provided') {
    const text = String(value ?? '').trim();
    return text.length === 0 ? fallback : text;
}

function readDate(value) {
    if (!value) {
        return null;
    }

    if (value instanceof Date) {
        return value;
    }

    if (typeof value.toDate === 'function') {
        return value.toDate();
    }

    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
}

function formatDateTime(value) {
    const date = readDate(value);
    if (!date) {
        return 'Not available';
    }

    return new Intl.DateTimeFormat('en-LK', {
        dateStyle: 'medium',
        timeStyle: 'short',
        timeZone: 'Asia/Colombo',
    }).format(date);
}

function formatDuration(startValue, endValue) {
    const start = readDate(startValue);
    const end = readDate(endValue);

    if (!start || !end) {
        return 'Not available';
    }

    const minutes = Math.max(0, Math.round((end.getTime() - start.getTime()) / 60000));
    if (minutes < 1) {
        return 'Less than 1 minute';
    }
    if (minutes < 60) {
        return `${minutes} min`;
    }

    const hours = Math.floor(minutes / 60);
    const remainingMinutes = minutes % 60;
    if (remainingMinutes === 0) {
        return `${hours} hr`;
    }

    return `${hours} hr ${remainingMinutes} min`;
}

function buildSection(title, body) {
    return `
        <div class="section">
            <h3>${escapeHtml(title)}</h3>
            ${body}
        </div>
    `;
}

function buildList(items) {
    return `
        <ul class="list">
            ${items.map((item) => `<li>${escapeHtml(item)}</li>`).join('')}
        </ul>
    `;
}

function buildTable(rows) {
    return `
        <table class="meta-table" cellpadding="0" cellspacing="0" role="presentation">
            <tbody>
                ${rows
            .map(
                ({ label, value }) => `
                            <tr>
                                <td class="label">${escapeHtml(label)}</td>
                                <td class="value">${escapeHtml(value)}</td>
                            </tr>
                        `
            )
            .join('')}
            </tbody>
        </table>
    `;
}

function buildEmailLayout({
    eyebrow,
    title,
    subtitle,
    accentColor,
    body,
    footer,
}) {
    return `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${escapeHtml(title)}</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f4f7fb;
            font-family: Arial, Helvetica, sans-serif;
            color: #10223b;
        }
        .shell {
            width: 100%;
            padding: 24px 12px;
            box-sizing: border-box;
        }
        .card {
            max-width: 680px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 18px 40px rgba(16, 34, 59, 0.12);
        }
        .hero {
            padding: 32px 32px 28px;
            color: #ffffff;
            background:
                radial-gradient(circle at top right, rgba(255,255,255,0.22), transparent 38%),
                linear-gradient(135deg, ${accentColor}, #0f172a);
        }
        .eyebrow {
            display: inline-block;
            padding: 8px 12px;
            margin-bottom: 16px;
            border-radius: 999px;
            background: rgba(255,255,255,0.18);
            font-size: 12px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            font-weight: 700;
        }
        .hero h1 {
            margin: 0 0 10px;
            font-size: 30px;
            line-height: 1.15;
        }
        .hero p {
            margin: 0;
            max-width: 540px;
            font-size: 15px;
            line-height: 1.7;
            color: rgba(255,255,255,0.92);
        }
        .content {
            padding: 28px 32px 32px;
        }
        .lead {
            margin: 0 0 20px;
            font-size: 15px;
            line-height: 1.75;
            color: #334155;
        }
        .section {
            margin-top: 22px;
            padding: 20px;
            background: linear-gradient(180deg, #fbfdff 0%, #f8fbff 100%);
            border: 1px solid #d9e6f5;
            border-radius: 18px;
        }
        .section h3 {
            margin: 0 0 14px;
            font-size: 18px;
            color: #0f172a;
        }
        .meta-table {
            width: 100%;
        }
        .meta-table td {
            padding: 9px 0;
            border-bottom: 1px solid #e5eef8;
            vertical-align: top;
            font-size: 14px;
        }
        .meta-table tr:last-child td {
            border-bottom: none;
        }
        .label {
            width: 36%;
            color: #64748b;
            font-weight: 700;
        }
        .value {
            color: #0f172a;
            font-weight: 600;
        }
        .message-box {
            padding: 16px 18px;
            border-radius: 16px;
            background: #0f172a;
            color: #f8fafc;
            font-size: 14px;
            line-height: 1.7;
            white-space: pre-wrap;
        }
        .list {
            margin: 0;
            padding-left: 18px;
            color: #334155;
        }
        .list li {
            margin-bottom: 10px;
            line-height: 1.6;
        }
        .pill-row {
            margin-top: 14px;
        }
        .pill {
            display: inline-block;
            margin-right: 8px;
            margin-bottom: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: #dbeafe;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: 700;
        }
        .footer {
            padding: 20px 32px 28px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.7;
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
        }
        .footer strong {
            color: #0f172a;
        }
        @media (max-width: 640px) {
            .hero, .content, .footer {
                padding-left: 20px;
                padding-right: 20px;
            }
            .hero h1 {
                font-size: 26px;
            }
            .label,
            .value {
                display: block;
                width: 100%;
            }
            .meta-table td {
                display: block;
                padding: 6px 0;
                border-bottom: none;
            }
        }
    </style>
</head>
<body>
    <div class="shell">
        <div class="card">
            <div class="hero">
                <div class="eyebrow">${escapeHtml(eyebrow)}</div>
                <h1>${escapeHtml(title)}</h1>
                <p>${escapeHtml(subtitle)}</p>
            </div>
            <div class="content">${body}</div>
            <div class="footer">${footer}</div>
        </div>
    </div>
</body>
</html>
    `;
}

async function getPassengerProfile(userId) {
    if (!userId) {
        return null;
    }

    const doc = await db.collection('passenger_details').doc(userId).get();
    return doc.exists ? doc.data() : null;
}

function getNotificationSettings(profile) {
    return profile?.preferences?.notifications || {};
}

function canSendFeedbackEmails(profile) {
    const settings = getNotificationSettings(profile);
    if (settings.emailEnabled === false) {
        return false;
    }

    return settings.feedbackEmails !== false;
}

function canSendJourneyEmails(profile) {
    const settings = getNotificationSettings(profile);
    if (settings.emailEnabled === false) {
        return false;
    }

    if (settings.journeyUpdates === false) {
        return false;
    }

    return settings.journeyEmails !== false;
}

function canSendSecurityEmails(profile) {
    const settings = getNotificationSettings(profile);
    if (settings.emailEnabled === false) {
        return false;
    }

    return settings.securityEmails !== false;
}

async function sendEmail({ to, subject, html, text }) {
    if (!to) {
        return { success: false, skipped: true, reason: 'missing_recipient' };
    }

    if (!hasEmailConfiguration()) {
        console.warn('Email skipped because SMTP configuration is missing.');
        return { success: false, skipped: true, reason: 'missing_configuration' };
    }

    const mailOptions = {
        from: `"${emailConfig.fromName}" <${emailConfig.fromEmail}>`,
        to,
        subject,
        html,
        text,
        replyTo: emailConfig.replyTo,
    };

    const transport = getTransporter();
    const info = await transport.sendMail(mailOptions);
    return { success: true, messageId: info.messageId };
}

function buildWelcomeEmail(profile) {
    const firstName = normalizeText(profile?.firstName, 'Traveler');
    const fullName = `${profile?.firstName || ''} ${profile?.lastName || ''}`.trim() || firstName;
    const createdAt = formatDateTime(profile?.createdAt);

    const body = `
        <p class="lead">Hello ${escapeHtml(firstName)}, your SafeDriver passenger account is ready. We have connected your ride history, safety tools, and support channels so you can start using the app immediately.</p>
        ${buildSection(
        'Account snapshot',
        buildTable([
            { label: 'Passenger name', value: fullName },
            { label: 'Email address', value: normalizeText(profile?.email) },
            { label: 'Phone number', value: normalizeText(profile?.phoneNumber) },
            { label: 'Created on', value: createdAt },
        ])
    )}
        ${buildSection(
        'What you can do next',
        buildList([
            'Track active buses and routes in real time.',
            'Start and end journeys with QR-based ride history.',
            'Send support requests and feedback from the app.',
            'Manage emergency contacts and safety preferences.',
        ])
    )}
        <div class="pill-row">
            <span class="pill">Journey tracking</span>
            <span class="pill">Safety alerts</span>
            <span class="pill">Support access</span>
        </div>
    `;

    return {
        subject: 'Welcome to SafeDriver',
        html: buildEmailLayout({
            eyebrow: 'New account',
            title: 'Welcome aboard',
            subtitle: 'Your passenger account is active and ready for secure daily travel.',
            accentColor: '#2563eb',
            body,
            footer: '<strong>SafeDriver</strong><br />This is an automated account email from your configured SafeDriver mail service.',
        }),
        text: `Welcome to SafeDriver, ${firstName}.

Your account is ready.
Email: ${normalizeText(profile?.email)}
Phone: ${normalizeText(profile?.phoneNumber)}
Created: ${createdAt}

You can now track buses, manage journeys, and use safety tools in the app.

SafeDriver`,
    };
}

function buildFeedbackUserEmail(profile, feedbackId, feedback) {
    const firstName = normalizeText(profile?.firstName, 'Traveler');
    const busNumber = normalizeText(feedback.busNumber, 'Not linked to a bus');
    const category = normalizeText(feedback.category, 'general');
    const rating = feedback.rating ? `${feedback.rating}/5` : 'Not rated';
    const submittedAt = formatDateTime(feedback.submittedAt);

    const body = `
        <p class="lead">Hello ${escapeHtml(firstName)}, we received your feedback and shared it with the SafeDriver team. Thank you for helping us improve ride quality and passenger safety.</p>
        ${buildSection(
        'Feedback summary',
        buildTable([
            { label: 'Reference', value: feedbackId },
            { label: 'Bus number', value: busNumber },
            { label: 'Category', value: category },
            { label: 'Rating', value: rating },
            { label: 'Submitted', value: submittedAt },
        ])
    )}
        ${buildSection(
        'Your message',
        `<div class="message-box">${escapeHtml(feedback.message)}</div>`
    )}
        ${buildSection(
        'What happens next',
        buildList([
            'Our support team reviews each submission.',
            'High-priority safety concerns are escalated faster.',
            'If more details are needed, we may contact you using your account email.',
        ])
    )}
    `;

    return {
        subject: 'We received your SafeDriver feedback',
        html: buildEmailLayout({
            eyebrow: 'Feedback received',
            title: 'Your feedback is now in review',
            subtitle: 'A copy of your submission is below for your records.',
            accentColor: '#0f766e',
            body,
            footer: '<strong>SafeDriver Support</strong><br />This confirmation was sent from your configured SafeDriver support mailbox.',
        }),
        text: `We received your SafeDriver feedback.

Reference: ${feedbackId}
Bus number: ${busNumber}
Category: ${category}
Rating: ${rating}
Submitted: ${submittedAt}

Message:
${feedback.message}

SafeDriver Support`,
    };
}

function buildFeedbackAdminEmail(profile, feedbackId, feedback) {
    const passengerName = `${profile?.firstName || ''} ${profile?.lastName || ''}`.trim() || 'Passenger';
    const rating = feedback.rating ? `${feedback.rating}/5` : 'Not rated';

    const body = `
        <p class="lead">A new passenger feedback item was created in SafeDriver. Review the details below and follow up where needed.</p>
        ${buildSection(
        'Submission details',
        buildTable([
            { label: 'Feedback ID', value: feedbackId },
            { label: 'Passenger', value: passengerName },
            { label: 'Passenger email', value: normalizeText(profile?.email) },
            { label: 'Phone number', value: normalizeText(profile?.phoneNumber) },
            { label: 'Bus number', value: normalizeText(feedback.busNumber, 'Not linked') },
            { label: 'Driver name', value: normalizeText(feedback.driverName, 'Not linked') },
            { label: 'Route number', value: normalizeText(feedback.routeNumber, 'Not linked') },
            { label: 'Category', value: normalizeText(feedback.category, 'general') },
            { label: 'Rating', value: rating },
            { label: 'Priority', value: normalizeText(feedback.priority, 'medium') },
            { label: 'Submitted', value: formatDateTime(feedback.submittedAt) },
        ])
    )}
        ${buildSection(
        'Passenger message',
        `<div class="message-box">${escapeHtml(feedback.message)}</div>`
    )}
    `;

    return {
        subject: `New feedback received${feedback.busNumber ? ` for bus ${feedback.busNumber}` : ''}`,
        html: buildEmailLayout({
            eyebrow: 'Admin copy',
            title: 'New passenger feedback submitted',
            subtitle: 'This copy was delivered to the configured SafeDriver admin mailbox.',
            accentColor: '#dc2626',
            body,
            footer: '<strong>SafeDriver Admin</strong><br />This alert was generated automatically from the feedback workflow.',
        }),
        text: `New passenger feedback submitted.

Feedback ID: ${feedbackId}
Passenger: ${passengerName}
Passenger email: ${normalizeText(profile?.email)}
Phone number: ${normalizeText(profile?.phoneNumber)}
Bus number: ${normalizeText(feedback.busNumber, 'Not linked')}
Driver name: ${normalizeText(feedback.driverName, 'Not linked')}
Route number: ${normalizeText(feedback.routeNumber, 'Not linked')}
Category: ${normalizeText(feedback.category, 'general')}
Rating: ${rating}
Priority: ${normalizeText(feedback.priority, 'medium')}
Submitted: ${formatDateTime(feedback.submittedAt)}

Message:
${feedback.message}

SafeDriver Admin`,
    };
}

function buildPasswordChangedEmail(profile, source, changedAt) {
    const firstName = normalizeText(profile?.firstName, 'Traveler');
    const changedSource = source === 'otp_reset' ? 'Password reset via phone verification' : 'Password updated from the app';
    const body = `
        <p class="lead">Hello ${escapeHtml(firstName)}, this is a security confirmation that your SafeDriver account password was changed successfully.</p>
        ${buildSection(
        'Security event',
        buildTable([
            { label: 'Account email', value: normalizeText(profile?.email) },
            { label: 'Change type', value: changedSource },
            { label: 'Changed at', value: formatDateTime(changedAt) },
        ])
    )}
        ${buildSection(
        'If this was not you',
        buildList([
            'Reset your password immediately from the SafeDriver sign-in screen.',
            'Review recent account activity and update trusted contact details.',
            'Contact support as soon as possible so we can help secure the account.',
        ])
    )}
    `;

    return {
        subject: 'Your SafeDriver password was changed',
        html: buildEmailLayout({
            eyebrow: 'Security alert',
            title: 'Password update confirmed',
            subtitle: 'We are sending this for your records and account safety.',
            accentColor: '#b45309',
            body,
            footer: '<strong>SafeDriver Security</strong><br />Keep this message for your records. Contact support immediately if you did not perform this action.',
        }),
        text: `Your SafeDriver password was changed.

Account email: ${normalizeText(profile?.email)}
Change type: ${changedSource}
Changed at: ${formatDateTime(changedAt)}

If this was not you, reset the password again and contact SafeDriver support immediately.

SafeDriver Security`,
    };
}

function buildJourneyCompletedEmail(profile, journeyId, journey) {
    const firstName = normalizeText(profile?.firstName, 'Traveler');
    const startedAt = readDate(journey.startedAt);
    const endedAt = readDate(journey.endedAt);

    const body = `
        <p class="lead">Hello ${escapeHtml(firstName)}, your SafeDriver journey has ended. Here is a clean receipt-style summary for your trip history.</p>
        ${buildSection(
        'Journey details',
        buildTable([
            { label: 'Journey ID', value: journeyId },
            { label: 'Bus number', value: normalizeText(journey.busNumber, 'Not available') },
            { label: 'Route number', value: normalizeText(journey.routeNumber, 'Not available') },
            { label: 'Driver name', value: normalizeText(journey.driverName, 'Not available') },
            { label: 'Started', value: formatDateTime(startedAt) },
            { label: 'Ended', value: formatDateTime(endedAt) },
            { label: 'Duration', value: formatDuration(startedAt, endedAt) },
            { label: 'Ended reason', value: normalizeText(journey.endedReason, 'Completed') },
        ])
    )}
        ${buildSection(
        'Trip note',
        `<div class="message-box">Thank you for travelling with SafeDriver. You can review this trip again from Trip History inside the app.</div>`
    )}
    `;

    return {
        subject: `Journey completed${journey.busNumber ? ` on bus ${journey.busNumber}` : ''}`,
        html: buildEmailLayout({
            eyebrow: 'Journey receipt',
            title: 'Your trip summary is ready',
            subtitle: 'SafeDriver recorded the end of your journey and prepared a summary for your records.',
            accentColor: '#1d4ed8',
            body,
            footer: '<strong>SafeDriver Journeys</strong><br />Trip summaries are sent from your configured SafeDriver mailbox when journey email updates are enabled.',
        }),
        text: `Your SafeDriver journey has ended.

Journey ID: ${journeyId}
Bus number: ${normalizeText(journey.busNumber, 'Not available')}
Route number: ${normalizeText(journey.routeNumber, 'Not available')}
Driver name: ${normalizeText(journey.driverName, 'Not available')}
Started: ${formatDateTime(startedAt)}
Ended: ${formatDateTime(endedAt)}
Duration: ${formatDuration(startedAt, endedAt)}
Ended reason: ${normalizeText(journey.endedReason, 'Completed')}

SafeDriver Journeys`,
    };
}

function normalizeFeedbackDocument(feedbackDoc) {
    const ratingValue =
        typeof feedbackDoc?.rating?.overall === 'number'
            ? feedbackDoc.rating.overall
            : typeof feedbackDoc?.rating === 'number'
                ? feedbackDoc.rating
                : null;

    return {
        busNumber: feedbackDoc?.busNumber || feedbackDoc?.passengerInfo?.busNumber || '',
        driverName: feedbackDoc?.driverName || '',
        routeNumber: feedbackDoc?.routeNumber || '',
        category: feedbackDoc?.category || '',
        priority: feedbackDoc?.priority || '',
        rating: ratingValue,
        message:
            feedbackDoc?.description ||
            feedbackDoc?.comment ||
            feedbackDoc?.title ||
            'No feedback message provided.',
        submittedAt:
            feedbackDoc?.submittedAt ||
            feedbackDoc?.createdAt ||
            feedbackDoc?.timestamp ||
            feedbackDoc?.updatedAt,
    };
}

async function sendWelcomeEmailInternal({ userId, profile }) {
    const passengerProfile = profile || (await getPassengerProfile(userId));
    if (!passengerProfile?.email) {
        return { success: false, skipped: true, reason: 'missing_email' };
    }

    const email = buildWelcomeEmail(passengerProfile);
    return sendEmail({
        to: passengerProfile.email,
        subject: email.subject,
        html: email.html,
        text: email.text,
    });
}

async function sendFeedbackEmailsInternal({ feedbackId, feedbackData }) {
    const profile = await getPassengerProfile(feedbackData.userId);
    const feedback = normalizeFeedbackDocument(feedbackData);
    const userResults = { success: false, skipped: true, reason: 'preference_disabled' };
    let adminResults = { success: false, skipped: true, reason: 'missing_admin_email' };

    if (profile?.email && canSendFeedbackEmails(profile)) {
        const userEmail = buildFeedbackUserEmail(profile, feedbackId, feedback);
        Object.assign(
            userResults,
            await sendEmail({
                to: profile.email,
                subject: userEmail.subject,
                html: userEmail.html,
                text: userEmail.text,
            })
        );
    }

    if (emailConfig.adminEmail) {
        const adminEmail = buildFeedbackAdminEmail(profile, feedbackId, feedback);
        adminResults = await sendEmail({
            to: emailConfig.adminEmail,
            subject: adminEmail.subject,
            html: adminEmail.html,
            text: adminEmail.text,
        });
    }

    return {
        success: userResults.success || adminResults.success,
        user: userResults,
        admin: adminResults,
    };
}

async function sendPasswordChangedEmailInternal({ userId, email, source = 'in_app_change', changedAt = new Date() }) {
    const profile = await getPassengerProfile(userId);
    const recipient = email || profile?.email;

    if (!recipient) {
        return { success: false, skipped: true, reason: 'missing_email' };
    }

    if (profile && !canSendSecurityEmails(profile)) {
        return { success: false, skipped: true, reason: 'preference_disabled' };
    }

    const mergedProfile = {
        ...(profile || {}),
        email: recipient,
    };
    const message = buildPasswordChangedEmail(mergedProfile, source, changedAt);

    return sendEmail({
        to: recipient,
        subject: message.subject,
        html: message.html,
        text: message.text,
    });
}

async function sendJourneyCompletedEmailInternal({ journeyId, journeyData }) {
    const profile = await getPassengerProfile(journeyData.userId);
    if (!profile?.email) {
        return { success: false, skipped: true, reason: 'missing_email' };
    }

    if (!canSendJourneyEmails(profile)) {
        return { success: false, skipped: true, reason: 'preference_disabled' };
    }

    const email = buildJourneyCompletedEmail(profile, journeyId, journeyData);
    return sendEmail({
        to: profile.email,
        subject: email.subject,
        html: email.html,
        text: email.text,
    });
}

const emailExports = {
    sendWelcomeEmailOnPassengerCreate: functions
        .region(region)
        .firestore.document('passenger_details/{userId}')
        .onCreate(async (snap, context) => {
            try {
                return await sendWelcomeEmailInternal({
                    userId: context.params.userId,
                    profile: snap.data(),
                });
            } catch (error) {
                console.error('Welcome email failed:', error);
                return { success: false, error: error.message };
            }
        }),

    sendFeedbackEmailsOnCreate: functions
        .region(region)
        .firestore.document('feedback/{feedbackId}')
        .onCreate(async (snap, context) => {
            try {
                return await sendFeedbackEmailsInternal({
                    feedbackId: context.params.feedbackId,
                    feedbackData: snap.data(),
                });
            } catch (error) {
                console.error('Feedback email failed:', error);
                return { success: false, error: error.message };
            }
        }),

    sendJourneyCompletedEmailOnUpdate: functions
        .region(region)
        .firestore.document('journeys/{journeyId}')
        .onUpdate(async (change, context) => {
            const before = change.before.data();
            const after = change.after.data();

            if (before?.status === after?.status || after?.status !== 'completed') {
                return { success: false, skipped: true, reason: 'status_not_completed' };
            }

            try {
                return await sendJourneyCompletedEmailInternal({
                    journeyId: context.params.journeyId,
                    journeyData: after,
                });
            } catch (error) {
                console.error('Journey completion email failed:', error);
                return { success: false, error: error.message };
            }
        }),

    sendPasswordChangedEmail: functions
        .region(region)
        .https.onCall(async (data, context) => {
            if (!context.auth) {
                throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
            }

            try {
                const result = await sendPasswordChangedEmailInternal({
                    userId: context.auth.uid,
                    source: data?.source || 'in_app_change',
                    changedAt: new Date(),
                });

                return {
                    success: result.success,
                    skipped: result.skipped || false,
                    reason: result.reason || null,
                };
            } catch (error) {
                console.error('Password email callable failed:', error);
                throw new functions.https.HttpsError('internal', error.message);
            }
        }),
};

module.exports = {
    emailExports,
    sendPasswordChangedEmailInternal,
};
