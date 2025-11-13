# 🔥 SafeDriver Cloud Functions - SMS Gateway

Firebase Cloud Functions for SafeDriver's SMS-based authentication using Text.lk SMS gateway.

## 🚀 Quick Start

### 1. Setup
```bash
# Run the setup script
./setup.sh

# Or manually:
npm install
cp .env.example .env
```

### 2. Configure
Edit `.env` file with your Text.lk API credentials:

```env
TEXTLK_API_TOKEN=2171|Hp874DmptWQNEk16DOGaXvvORW7lQwVIz0YAuYhB5ea59f6b
TEXTLK_SENDER_ID=TextLKDemo
```

### 3. Deploy
```bash
# Quick deploy with validation
./deploy.sh

# Or manually:
firebase deploy --only functions
```

## 📚 Functions

### `sendOTP`
Sends OTP via Text.lk SMS gateway to Sri Lankan phone numbers.

**Request:**
```json
{
  "phoneNumber": "+94771234567"
}
```

**Response:**
```json
{
  "success": true,
  "verificationId": "uuid-here",
  "phoneNumber": "+94771234567",
  "expiresAt": "2024-11-14T12:10:00.000Z"
}
```

### `verifyOTP`
Verifies OTP code and authenticates user.

**Request:**
```json
{
  "verificationId": "uuid-here",
  "otp": "123456",
  "phoneNumber": "+94771234567"
}
```

**Response:**
```json
{
  "success": true,
  "customToken": "firebase-custom-token",
  "userId": "firebase-user-id",
  "phoneNumber": "+94771234567",
  "isNewUser": true
}
```

### `healthCheck`
System health monitoring endpoint.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-11-14T12:00:00.000Z",
  "region": "asia-south1",
  "service": "safe-driver-sms-gateway"
}
```

### `cleanupExpiredOTPs`
Scheduled function (runs hourly) to clean up expired OTP records.

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TEXTLK_API_TOKEN` | Text.lk API token | Required |
| `TEXTLK_API_URL` | Text.lk API endpoint | `https://app.text.lk/api/v3/sms/send` |
| `TEXTLK_SENDER_ID` | Approved sender ID | `TextLKDemo` |
| `OTP_EXPIRY_MINUTES` | OTP expiration time | `10` |
| `OTP_MAX_ATTEMPTS` | Max verification attempts | `3` |
| `OTP_LENGTH` | OTP code length | `6` |
| `DEBUG_MODE` | Enable debug logging | `false` |

### Rate Limiting

- **OTP Requests**: 3 per hour per phone number
- **Verification Attempts**: 5 per 5 minutes per phone number

## 🧪 Testing

### Local Testing
```bash
# Start emulators
firebase emulators:start

# Test sendOTP function
curl -X POST http://localhost:5001/safe-driver-system/asia-south1/sendOTP \
  -H "Content-Type: application/json" \
  -d '{"data": {"phoneNumber": "+94771234567"}}'
```

### Production Testing
```bash
# Test health check
curl https://asia-south1-safe-driver-system.cloudfunctions.net/healthCheck

# Monitor logs
firebase functions:log --follow
```

## 📊 Monitoring

### Logs
```bash
# View all function logs
firebase functions:log

# View specific function logs
firebase functions:log --only sendOTP

# Follow logs in real-time
firebase functions:log --follow
```

### Metrics
- Function execution time
- SMS delivery success rate
- Error rates and patterns
- Cost tracking

## 🛡️ Security Features

- **Rate Limiting**: Prevents SMS flooding attacks
- **OTP Hashing**: SHA-256 hashing before storage
- **Phone Validation**: Sri Lankan number format validation
- **Attempt Limiting**: Maximum 3 verification attempts
- **TTL**: Automatic cleanup of expired records
- **Input Validation**: Comprehensive request validation

## 🌍 Sri Lankan Phone Number Support

Supports all major Sri Lankan carriers:
- Dialog (077, 070)
- Mobitel (071, 072)
- Hutch (078)
- Airtel (070, 075)

Format: `+94XXXXXXXXX` (without leading zero)

## 💰 Cost Estimation

**Monthly costs for 1,000 authentications:**
- Firebase Functions: ~$5-10
- Firestore operations: ~$1-2
- Text.lk SMS: ~$20-50 (LKR 0.50-1.25 per SMS)
- **Total**: ~$26-62 per month

## 🔍 Troubleshooting

### Common Issues

1. **OTP not received**
   - Check Text.lk dashboard for delivery status
   - Verify phone number format
   - Check SMS credits balance

2. **Function deployment fails**
   - Ensure `.env` file exists with valid credentials
   - Check Firebase billing is enabled
   - Verify Node.js version (18+)

3. **Authentication errors**
   - Check Firebase configuration
   - Verify custom token generation
   - Review Firestore security rules

### Debug Commands
```bash
# Check function status
firebase functions:list

# View detailed logs
firebase functions:log --only sendOTP --lines 50

# Test locally
firebase functions:shell
```

## 📞 Support

- **Text.lk Support**: support@text.lk
- **Firebase Support**: Firebase Console → Support
- **Technical Issues**: Create GitHub issue

## 📄 License

Part of SafeDriver project - All rights reserved.

---

**Last Updated**: November 14, 2024  
**Version**: 2.0.0  
**API Version**: Text.lk API v3