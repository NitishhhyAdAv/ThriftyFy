import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current Firebase user
  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  /// Sign in with phone number
  /// Returns the verification ID needed to complete sign-in
  Future<String?> signInWithPhoneNumber(
    String phoneNumber, {
    required Function(PhoneAuthCredential) onCodeSent,
    required Function(String, PlatformException) onVerificationFailed,
    required Function(PhoneAuthCredential) onCodeAutoRetrievalTimeout,
  }) async {
    try {
      String? verificationId;

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-signed in (Android)
          await _firebaseAuth.signInWithCredential(credential);
          onCodeSent(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(
            e.code,
            PlatformException(code: e.code, message: e.message),
          );
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          onCodeSent(
            PhoneAuthCredential(
              verificationId: verId,
              smsCode: '',
              signInMethod: 'phone',
              providerId: 'phone',
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
          onCodeAutoRetrievalTimeout(
            PhoneAuthCredential(
              verificationId: verId,
              smsCode: '',
              signInMethod: 'phone',
              providerId: 'phone',
            ),
          );
        },
      );

      return verificationId;
    } catch (e) {
      print('Error signing in with phone: $e');
      return null;
    }
  }

  /// Verify OTP and complete phone sign-in
  Future<UserCredential?> verifyPhoneOTP(
    String verificationId,
    String otp,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }

  /// Email and password sign up
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  /// Email and password login
  Future<UserCredential?> loginWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  /// Get user email or phone number
  String? getUserIdentifier() {
    final user = currentFirebaseUser;
    return user?.email ?? user?.phoneNumber;
  }

  /// Check if user is authenticated
  bool isUserAuthenticated() {
    return currentFirebaseUser != null;
  }
}
