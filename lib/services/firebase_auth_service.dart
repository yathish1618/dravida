import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email Signup with Name
  Future<User?> signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload(); // Refresh user info

      return _auth.currentUser; // Return updated user
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Email Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}