# Thriftfy Authentication - Quick Start Guide

## What Was Implemented

Your Thriftfy app now has complete Gmail and Phone authentication integrated with Firebase, occurring right after users select their role (Buyer or Seller).

## Quick Setup (5 Minutes)

### 1. Get Firebase Credentials
1. Go to https://console.firebase.google.com
2. Create a new project named "Thriftfy"
3. Add Android app (package: `com.thriftfy.app`) → Download `google-services.json`
4. Add iOS app (bundle: `com.thriftfy.app`) → Download `GoogleService-Info.plist`

### 2. Add Files
- Place `google-services.json` in `android/app/`
- Place `GoogleService-Info.plist` in `ios/Runner/` (add to Xcode)

### 3. Enable Firebase Auth Methods
In Firebase Console:
- **Build → Authentication → Get started**
- Enable: **Google**, **Phone**, **Email/Password**

### 4. Configure Google Sign-In (Android)
1. Get your SHA-1: Run `keytool -list -v -keystore ~/.android/debug.keystore`
2. Add SHA-1 to your Android app in Firebase Console

### 5. Run the App
```bash
flutter pub get
flutter run
```

## User Flow

```
Welcome Screen (Select Role)
         ↓
    Login Page
    ├─ Email/Password
    ├─ Gmail (Cloud icon)
    └─ Phone (Mobile icon)
         ↓
   Dashboard
    ├─ Profile tab → Logout button
    └─ Role-specific features
```

## Testing

### Test Email/Password
- Email: `buyer@example.com`
- Password: `password123`

### Test Gmail
- Click "Gmail" button → Sign in with your Google account

### Test Phone (Use Test Numbers)
1. In Firebase: **Build → Authentication → Phone → Add test numbers**
2. Add: `+1-555-123-4567`
3. Set test code: `123456`
4. In app: Click "Phone" → Enter test number → Enter code

### Test Logout
- Tap Profile tab → "Logout" button → Back to Welcome screen

## Key Features

✅ **Gmail Sign-In** - One-tap Google authentication  
✅ **Phone OTP** - Two-step phone verification  
✅ **Email/Password** - Traditional login  
✅ **Role Selection** - Buyer/Seller modes  
✅ **Logout** - Clean Firebase sign-out  
✅ **Auto Sign-In** - Remember logged-in users  

## File Changes

### New Files
- `lib/services/auth_service.dart` - Firebase auth logic
- `lib/screens/phone_auth_screen.dart` - Phone verification UI
- `FIREBASE_SETUP.md` - Detailed Firebase config
- `AUTH_IMPLEMENTATION.md` - Complete documentation

### Modified Files
- `pubspec.yaml` - Added Firebase packages
- `lib/main.dart` - Firebase initialization
- `lib/login_page.dart` - Gmail/Phone buttons
- `lib/data/mock_service.dart` - Enhanced logout
- `lib/screens/main_layout.dart` - Logout functionality

## Important Notes

⚠️ **Before Production:**
1. Set up proper Firebase security rules
2. Add email verification
3. Implement password reset
4. Configure reCAPTCHA for phone auth
5. Store user data in Firestore

⚠️ **Firebase Credentials:**
- Never commit `google-services.json` to public repos
- Never commit `GoogleService-Info.plist` to public repos
- Add these to `.gitignore`

## Troubleshooting

### App Won't Run
```bash
flutter clean
flutter pub get
flutter run
```

### Gmail Button Doesn't Work
- Check SHA-1 fingerprint is added to Firebase Console
- Verify OAuth client ID in Firebase Project Settings

### Phone Auth Not Sending OTP
- Use test phone numbers from Firebase Console
- Check SMS provider is enabled for your region

### Logout Button Grayed Out
- Ensure `logoutAsync()` method completed
- Check Firebase sign-out didn't fail

## Next Steps

1. **Set up Firestore** for user data persistence
2. **Add profile editing** with image upload
3. **Implement email verification** for security
4. **Add password reset** functionality
5. **Set up Cloud Storage** for user avatars

## Documentation

- 📄 **FIREBASE_SETUP.md** - Detailed Firebase setup guide
- 📄 **AUTH_IMPLEMENTATION.md** - Complete architecture documentation
- 💻 **lib/services/auth_service.dart** - Inline code documentation

## Need Help?

### Debug Mode
Enable Firebase debug logging in `lib/services/auth_service.dart`:
```dart
// Add at start of main.dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Debug logging
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    print('Auth state changed: ${user?.email}');
  });
  // ... rest of code
}
```

### Common Commands
```bash
# Clear and reinstall
flutter clean && flutter pub get

# Run with specific platform
flutter run -d web     # Web browser
flutter run -d windows # Windows
flutter run -d macos   # macOS

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release
```

## Support Resources

- Firebase Documentation: https://firebase.flutter.dev/
- Google Sign-In: https://pub.dev/packages/google_sign_in
- Firebase Auth: https://pub.dev/packages/firebase_auth
- Flutter Docs: https://flutter.dev/docs

---

**Authentication successfully integrated!** 🎉

Your app now supports Gmail and Phone authentication with proper logout management. Follow the quick setup steps above and refer to the documentation files for detailed configuration.
