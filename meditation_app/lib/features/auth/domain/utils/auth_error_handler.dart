import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'The password is invalid for this email.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email but different sign-in credentials.';
        case 'invalid-credential':
          return 'The credential is invalid.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'too-many-requests':
          return 'Too many unsuccessful login attempts. Please try again later.';
        case 'requires-recent-login':
          return 'This operation requires recent authentication. Please log in again.';
        default:
          return 'An unknown error occurred: ${error.code}';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
