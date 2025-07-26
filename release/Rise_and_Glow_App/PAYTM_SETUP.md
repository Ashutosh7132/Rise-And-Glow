# Paytm Integration Setup Guide

This guide will help you set up Paytm payment integration for the Rise and Glow app.

## Prerequisites

1. **Paytm Merchant Account**: Sign up at [Paytm Business Portal](https://business.paytm.com/)
2. **Flutter SDK**: Version 3.2.5 or higher
3. **Android/iOS Development Environment**

## Step 1: Get Paytm Credentials

1. Login to [Paytm Business Portal](https://business.paytm.com/)
2. Navigate to **API Keys** section
3. Note down the following credentials:
   - **Merchant ID (MID)**
   - **Merchant Key**
   - **Website** (DEFAULT for production, WEBSTAGING for staging)

## Step 2: Update Configuration

Open `lib/services/payment_service.dart` and update the following constants:

```dart
// Replace these with your actual Paytm credentials
static const String _merchantId = "YOUR_ACTUAL_MERCHANT_ID";
static const String _merchantKey = "YOUR_ACTUAL_MERCHANT_KEY";
static const String _website = "DEFAULT"; // Use "WEBSTAGING" for testing
static const String _callbackUrl = "https://your-server.com/paytm/callback";
static const String _environment = "production"; // Use "staging" for testing
```

## Step 3: Android Configuration

### 3.1 Update AndroidManifest.xml

Add the following permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
```

### 3.2 Add Activity for Paytm

Add this activity inside the `<application>` tag:

```xml
<activity
    android:name="com.paytm.pgsdk.PaytmPGActivity"
    android:configChanges="keyboardHidden|orientation|keyboard"
    android:exported="true"
    android:screenOrientation="portrait"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

## Step 4: iOS Configuration

### 4.1 Update Info.plist

Add the following to `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>paytm</string>
</array>
```

### 4.2 Add URL Scheme

Add your app's URL scheme for callback handling:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>your.app.bundle.id</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your-app-scheme</string>
        </array>
    </dict>
</array>
```

## Step 5: Backend Setup (Required for Production)

For production, you need a backend server to:

1. **Generate Checksums**: Never expose merchant key in client
2. **Verify Payments**: Validate transaction status
3. **Handle Callbacks**: Process payment responses

### Sample Backend Endpoint (Node.js/Express)

```javascript
const crypto = require('crypto');
const axios = require('axios');

// Generate checksum
app.post('/generate-checksum', (req, res) => {
    const params = req.body;
    const merchantKey = process.env.PAYTM_MERCHANT_KEY;
    
    // Generate checksum logic here
    const checksum = generateChecksum(params, merchantKey);
    
    res.json({ checksum });
});

// Verify payment
app.post('/verify-payment', (req, res) => {
    const { orderId, txnId } = req.body;
    
    // Call Paytm verification API
    // Return verification result
});
```

## Step 6: Testing

### Test Credentials (Staging)

For testing purposes, you can use Paytm's test credentials:

```dart
// Test configuration
static const String _merchantId = "YOUR_TEST_MERCHANT_ID";
static const String _merchantKey = "YOUR_TEST_MERCHANT_KEY";
static const String _website = "WEBSTAGING";
static const String _environment = "staging";
```

### Test Cards

Use these test card details for testing:

- **Card Number**: 4111111111111111
- **Expiry**: Any future date
- **CVV**: Any 3 digits
- **OTP**: 489871

## Step 7: Security Best Practices

1. **Never store sensitive data** in client-side code
2. **Use HTTPS** for all communication
3. **Validate all transactions** on your backend
4. **Implement proper error handling**
5. **Log transactions** for debugging and auditing

## Troubleshooting

### Common Issues

1. **Checksum Mismatch**: Ensure parameters are sorted correctly
2. **Network Issues**: Check internet connectivity
3. **Invalid Merchant**: Verify merchant credentials
4. **App Restrictions**: Ensure app is not restricted from accessing Paytm

### Debug Mode

Enable debug logging by setting:

```dart
const bool kDebugMode = true; // Only for development
```

## Production Checklist

- [ ] Updated merchant credentials
- [ ] Backend server for checksum generation
- [ ] Payment verification endpoint
- [ ] Error handling and logging
- [ ] Security measures implemented
- [ ] Tested on physical devices
- [ ] App store compliance checked

## Support

For technical support:
- **Paytm Developer Portal**: [https://developer.paytm.com/](https://developer.paytm.com/)
- **Documentation**: [https://developer.paytm.com/docs/](https://developer.paytm.com/docs/)
- **Support Email**: support@paytm.com

## Important Notes

⚠️ **Never commit merchant keys to version control**
⚠️ **Always test on physical devices before production**
⚠️ **Implement proper error handling for failed payments**
⚠️ **Verify all transactions on your backend**

---

For more detailed implementation, refer to the official Paytm documentation.
