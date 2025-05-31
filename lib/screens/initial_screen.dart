import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

/// This widget acts as a gatekeeper for the root route.
/// It returns the HomeScreen if there is no authenticated user,
/// or the WelcomeScreen (which shows "Hello, <name>!" and redirects) if a user exists.
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user from Firebase Auth.
    final user = FirebaseAuth.instance.currentUser;

    // If the user is null, we are not logged in, so show HomeScreen.
    if (user == null) {
      return const HomeScreen();
    } else {
      // If a user is present (including anonymous), show the WelcomeScreen.
      return const WelcomeScreen();
    }
  }
}
