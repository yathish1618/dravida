import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email Signup with Name
  Future<User?> signUpWithEmail(String name, String email, String password) async {
    try {
      // Create a user using email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Update the display name of the newly created user
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload(); // Refresh user info

      return _auth.currentUser; // Return the updated user
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Email Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // Cancelled login

      // Retrieve authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a new credential using the token and idToken from Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Use the credential to sign in with Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // *** NEW: Anonymous Sign-In for Skip Login functionality ***
  Future<User?> signInAnonymously() async {
    try {
      // Sign in anonymously with Firebase's built-in method
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Error signing in anonymously: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    // Sign out from Firebase and, if needed, from Google as well.
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
