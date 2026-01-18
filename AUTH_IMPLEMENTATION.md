# Thriftfy Authentication Implementation

## Overview

This document describes the Gmail/Phone authentication system implemented in the Thriftfy app. The authentication flow occurs after users select their role (Buyer or Seller).

## Architecture

### Services

#### `AuthService` (`lib/services/auth_service.dart`)
Handles all Firebase authentication operations:
- **Google Sign-In**: `signInWithGoogle()`
- **Phone Authentication**: `signInWithPhoneNumber()` and `verifyPhoneOTP()`
- **Email/Password**: `loginWithEmail()` and `signUpWithEmail()`
- **Sign Out**: `signOut()`
- **State Management**: `authStateChanges` stream and `isUserAuthenticated()`

#### `MockService` (`lib/data/mock_service.dart`)
Manages local user state and persistence:
- `loginWithAuth()`: Creates or updates user profile after authentication
- `logoutAsync()`: Clears auth state and signs out from Firebase
- User data caching and retrieval

### Screens

#### `WelcomeScreen` (`lib/screens/welcome_screen.dart`)
- Role selection (Buyer/Seller)
- Navigation to `LoginPage` after role selection

#### `LoginPage` (`lib/login_page.dart`)
- Email/Password login form
- Gmail sign-in button
- Phone sign-in button (redirects to `PhoneAuthScreen`)
- Handles traditional email/password authentication

#### `PhoneAuthScreen` (`lib/screens/phone_auth_screen.dart`)
- Two-step phone verification:
  1. Enter phone number → receive OTP
  2. Enter OTP → verify and sign in
- Real-time error handling and validation

#### `MainLayout` (`lib/screens/main_layout.dart`)
- Profile page with user information
- Logout button with async Firebase sign-out
- Role-based navigation (Buyer/Seller)

## Authentication Flow

```
WelcomeScreen
    ↓ (Select Buyer/Seller)
LoginPage
    ├→ Email/Password Login → MockService.login()
    ├→ Gmail Sign-In → AuthService.signInWithGoogle() → MockService.loginWithAuth()
    └→ Phone Sign-In → PhoneAuthScreen
            ├→ Enter Phone → AuthService.signInWithPhoneNumber()
            ├→ Enter OTP → AuthService.verifyPhoneOTP()
            └→ Verify → MockService.loginWithAuth()
    
    ↓
MainLayout (Dashboard)
    ├→ Buyer Dashboard
    ├→ Seller Dashboard
    └→ Profile → Logout → AuthService.signOut() + MockService.logoutAsync()
            ↓
        WelcomeScreen
```

## Key Features

### 1. Gmail Authentication
- Uses Firebase Google Sign-In
- Automatically creates user profile with display name and email
- Requires proper OAuth configuration in Firebase Console

### 2. Phone Authentication
- Firebase Phone Auth with OTP verification
- Two-step process for security
- Automatic and manual OTP retrieval options
- Resend OTP capability

### 3. Email/Password Authentication
- Traditional email/password login
- User auto-creation on first login
- Can be extended with registration form

### 4. Role-Based Access
- Users select Buyer or Seller role during login
- Role determines dashboard layout and features
- Persistent across app sessions

### 5. Logout Management
- Proper Firebase sign-out
- Google Sign-In account sign-out
- Local user state clearing
- Returns to welcome screen

## Implementation Details

### State Management

The app uses a combination of:
- **Firebase Auth**: For authentication state (backend)
- **MockService ChangeNotifier**: For local user state and UI updates
- **Provider** (added to pubspec.yaml): For potential future state management

### Error Handling

- Google Sign-In failures: SnackBar notification
- Phone OTP failures: Inline error messages with red background
- Network errors: User-friendly messages
- Validation: Phone number and OTP format validation

### Security

- Firebase handles secure credential storage
- Phone numbers are passed to Firebase securely
- OTP codes are time-limited and one-time use
- OAuth tokens are managed by Firebase

## Dependencies

```yaml
firebase_core: ^3.8.0          # Firebase core functionality
firebase_auth: ^5.3.0          # Firebase authentication
google_sign_in: ^6.2.2         # Google Sign-In integration
provider: ^6.4.3               # State management (optional, ready for expansion)
```

## Setup Instructions

### 1. Firebase Project Setup
See `FIREBASE_SETUP.md` for complete Firebase configuration guide.

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase Credentials
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`

### 4. Run the App
```bash
flutter run
```

## File Structure

```
lib/
├── services/
│   └── auth_service.dart          # Firebase authentication logic
├── screens/
│   ├── welcome_screen.dart        # Role selection
│   ├── phone_auth_screen.dart     # Phone verification
│   ├── main_layout.dart           # Dashboard with logout
│   └── [other screens]
├── data/
│   ├── models.dart                # User and Product models
│   └── mock_service.dart          # Local state management
├── login_page.dart                # Email/Gmail/Phone login
└── main.dart                      # App entry point with Firebase init
```

## Testing

### Manual Testing Checklist

- [ ] Gmail Sign-In (Buyer)
- [ ] Gmail Sign-In (Seller)
- [ ] Phone Auth (Buyer) - with test number
- [ ] Phone Auth (Seller) - with test number
- [ ] Email/Password Login
- [ ] User profile displays correctly
- [ ] Logout functionality clears auth
- [ ] Role-based dashboard shows correct layout
- [ ] Returning to app shows dashboard (not login)

### Automated Testing (Future)

Can be enhanced with integration tests using:
```bash
flutter test integration_test/
```

## Future Enhancements

1. **Password Reset**: Add forgot password functionality
2. **Email Verification**: Send confirmation emails
3. **Two-Factor Authentication**: Enhanced security
4. **Social Sign-In**: Facebook, Apple, GitHub
5. **Profile Editing**: Update user information
6. **Avatar Upload**: Cloud Storage integration
7. **Biometric Authentication**: Fingerprint/Face ID
8. **Account Linking**: Connect multiple auth methods

## Troubleshooting

### Common Issues

**Firebase Not Initializing**
- Check `google-services.json` location (android/app/)
- Check `GoogleService-Info.plist` added to Xcode
- Run `flutter clean` and `flutter pub get`

**Google Sign-In Fails**
- Verify SHA-1 fingerprint in Firebase Console
- Check OAuth client ID is correct
- Ensure Google APIs are enabled in Cloud Console

**Phone Auth Issues**
- Use test phone numbers for development
- Check SMS provider is enabled for your region
- Verify test OTP code in Firebase Console

**Navigation Issues**
- Ensure named routes are defined if using route names
- Check Widget mount status before navigation

## Support

For issues or questions:
1. Check Firebase documentation: https://firebase.flutter.dev/
2. Review Flutter Auth examples: https://github.com/firebase/FlutterFire
3. Check Google Sign-In docs: https://pub.dev/packages/google_sign_in
4. Review code comments in `AuthService` class
