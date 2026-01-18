# Firebase Configuration Guide for Thriftfy

This guide will help you set up Firebase for Gmail and Phone authentication in your Thriftfy app.

## Prerequisites

- Firebase project created at https://console.firebase.google.com
- Flutter installed and configured
- Android and iOS development environments set up

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a new project" or select an existing one
3. Name it "Thriftfy"
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Register Android App

1. In Firebase Console, click the Android icon
2. Enter package name: `com.thriftfy.app` (or your chosen package name)
3. Enter app nickname: `Thriftfy Android`
4. Download `google-services.json`
5. Place the file in `android/app/` directory
6. Follow the instructions to update `build.gradle` files

### Gradle Configuration

The build.gradle files should already be configured with the Google Services plugin. Verify:

**android/build.gradle:**
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

**android/app/build.gradle:**
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.firebase:firebase-core:21.4.0'
}
```

## Step 3: Register iOS App

1. In Firebase Console, click the iOS icon
2. Enter bundle ID: `com.thriftfy.app` (or your chosen bundle ID)
3. Enter app nickname: `Thriftfy iOS`
4. Download `GoogleService-Info.plist`
5. Add to Xcode: Open `ios/Runner.xcworkspace` and add the file to the Runner project
6. Follow the instructions to update iOS build configurations

## Step 4: Enable Authentication Methods

1. In Firebase Console, go to **Build → Authentication**
2. Click "Get started"
3. Enable these sign-in methods:

### Enable Google Sign-In
1. Click "Google"
2. Toggle "Enable"
3. Add a project support email
4. Click "Save"

### Enable Phone Authentication
1. Click "Phone"
2. Toggle "Enable"
3. Click "Save"

### Enable Email/Password (Optional)
1. Click "Email/Password"
2. Toggle "Enable"
3. Click "Save"

## Step 5: Configure Google Cloud for Google Sign-In

### For Android:

1. In Firebase Console, go to **Project Settings → Service Accounts**
2. Click "Generate new private key"
3. In `android/app/build.gradle`, add your SHA-1 fingerprint:

```bash
# Get SHA-1 from your keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

4. Go to **Project Settings → General → Your apps → Android app**
5. Add the SHA-1 fingerprint to the Android app configuration

### For iOS:

1. In Firebase Console, go to **Project Settings → General**
2. Download the `GoogleService-Info.plist` if not already done
3. Make sure it's added to Xcode (see Step 3)

## Step 6: Update Application Credentials

### For Google Sign-In on iOS:

Edit `ios/Runner/Info.plist` and add:

```xml
<key>GIDClientID</key>
<string>YOUR_OAUTH_CLIENT_ID.apps.googleusercontent.com</string>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_OAUTH_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Find your OAuth Client ID in Firebase Console under **Project Settings → Service Accounts**

## Step 7: Phone Authentication Setup

### SMS Provider Configuration

For phone authentication, Firebase needs to send SMS codes. By default, it uses:
- **For Production**: Firebase's default SMS provider
- **For Testing**: You can add test phone numbers in Firebase Console

### Add Test Phone Numbers (Development):

1. In Firebase Console, go to **Build → Authentication → Phone**
2. Scroll to "Phone numbers for testing"
3. Add test phone numbers (e.g., +1-555-123-4567)
4. Provide a test verification code

## Step 8: Testing

### Test Gmail Sign-In
1. Run the app: `flutter run`
2. Select "Buyer" or "Seller"
3. Tap the "Gmail" button
4. Sign in with your Google account
5. You should be logged in and see the dashboard

### Test Phone Authentication
1. Run the app: `flutter run`
2. Select "Buyer" or "Seller"
3. Tap the "Phone" button
4. Enter a test phone number (if using test numbers from Firebase)
5. Enter the test verification code
6. You should be logged in and see the dashboard

### Test Logout
1. Navigate to the Profile tab
2. Tap "Logout"
3. You should return to the Welcome screen

## Troubleshooting

### Firebase Not Initializing
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations
- Check that Firebase plugins are added to `pubspec.yaml`
- Try `flutter pub get` and `flutter clean`

### Google Sign-In Not Working
- Verify OAuth client ID is correct
- Check that SHA-1 fingerprint is registered in Firebase Console
- Ensure `google_sign_in` package is properly installed

### Phone Authentication Issues
- For testing, use the test phone numbers added in Firebase Console
- Ensure the test verification code is correct
- Check that SMS provider is enabled for your region

### iOS Specific Issues
- Open `ios/Runner.xcworkspace` (not `.xcodeproj`)
- Ensure `GoogleService-Info.plist` is added to Runner target
- Check iOS deployment target is >= 11.0

## Environment Variables (Optional)

If you want to use environment-specific Firebase configs, create a `.env` file:

```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
```

Then load it in `main.dart` using the `flutter_dotenv` package.

## Security Considerations

1. **Never commit secrets**: Add `google-services.json` and `GoogleService-Info.plist` to `.gitignore` in production
2. **Use Security Rules**: Configure Firestore/Realtime Database security rules
3. **Validate Tokens**: Verify auth tokens on your backend
4. **Phone Number Privacy**: Ensure compliance with local regulations when storing phone numbers

## Next Steps

1. Set up Firestore or Realtime Database for user data
2. Implement profile picture storage using Cloud Storage
3. Add email verification
4. Implement password reset functionality
5. Add two-factor authentication (2FA) for enhanced security
