import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper method to map FirebaseAuthException codes to user-friendly messages.
  String _getErrorMessage(FirebaseAuthException e) {
    final code = e.code.toLowerCase();
    if (code.contains('wrong-password')) {
      return "Incorrect password.";
    } else if (code.contains('user-not-found')) {
      return "No account found for this email.";
    } else if (code.contains('invalid-email')) {
      return "Invalid email address.";
    } else if (code.contains('user-disabled')) {
      return "This user has been disabled.";
    } else if (code.contains('too-many-requests')) {
      return "Too many requests. Try again later.";
    } else {
      return "Login failed. Please check your credentials.";
    }
  }

  // Register with Email & Password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Registration Error Code: ${e.code}");
      print("Registration Error Message: ${e.message}");
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      print("Registration Error: $e");
      throw Exception("An error occurred. Please try again.");
    }
  }

  // Login with Email & Password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Login Error Code: ${e.code}");
      print("Login Error Message: ${e.message}");
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      print("Login Error: $e");
      throw Exception("An error occurred. Please try again.");
    }
  }

  // Google Sign-In Implementation with account chooser
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Force sign-out to ensure the account chooser appears.
      await googleSignIn.signOut();
      
      // Trigger the authentication flow.
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in.
        return null;
      }

      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the new credential.
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
