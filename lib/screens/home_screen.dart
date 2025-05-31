import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_buttons.dart';
import '../services/firebase_auth_service.dart'; // Import authentication service

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instantiate FirebaseAuthService to call authentication methods.
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to avoid calling Navigator during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If a user is already logged in (including anonymous),
      // redirect to the Welcome Screen.
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate screen width for responsive button sizing.
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.7;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Apply a tessellated background image with an opacity filter.
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_banner.png"),
            repeat: ImageRepeat.repeat,
            scale: 2.0,
            filterQuality: FilterQuality.high,
            fit: BoxFit.none,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1),
              BlendMode.dstATop,
            ),
          ),
        ),
        // Split the screen into two parts: top (75%) for the logo and bottom (25%) for the colored banner.
        child: Column(
          children: [
            // TOP: 75% of the screen for the logo.
            Expanded(
              flex: 3, // 3 parts out of total 4 (75%).
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // BOTTOM: 25% of the screen for the banner with buttons.
            Expanded(
              flex: 1, // 1 part out of total 4 (25%).
              child: Container(
                width: double.infinity,
                // Banner with the specified color code.
                color: const Color(0xf1f0eaff),
                child: Center(
                  // Center the buttons vertically.
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Sign Up" button (drop shadow removed).
                      SizedBox(
                        width: buttonWidth,
                        child: LoginButton(
                          label: "Sign Up",
                          onPressed: () => Navigator.pushNamed(context, "/signup"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // "Log In" button (drop shadow removed).
                      SizedBox(
                        width: buttonWidth,
                        child: LoginButtonWhite(
                          label: "Log In",
                          onPressed: () => Navigator.pushNamed(context, "/login"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // "Skip Login" button (drop shadow removed).
                      SizedBox(
                        width: buttonWidth,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xff627264), // Text color white.
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                          ),
                          child: const Text("I want to use without an account."),
                          onPressed: () async {
                            // Call anonymous sign-in to create an anonymous user.
                            final user = await _authService.signInAnonymously();
                            if (user != null) {
                              // After successful anonymous login, redirect to the Welcome Screen.
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/welcome", (route) => false);
                            } else {
                              // If sign-in fails, show an error message.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Unable to sign in anonymously. Please try again."),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
