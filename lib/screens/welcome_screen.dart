import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  // Controls the opacity of the content for the fade animation.
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    
    // Delay for 2 seconds, then fade out the content,
    // followed by navigating to the modules screen after an additional 500ms.
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isVisible = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, "/modules"); // Navigate to Modules screen.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Container with background banner decoration, matching HomeScreen.
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("$imageAssetsBasePath""welcome_banner.png"),
            repeat: ImageRepeat.repeat,
            scale: 2.0,
            filterQuality: FilterQuality.high,
            fit: BoxFit.none,
            colorFilter:
                ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),
          ),
        ),
        child: Center(
          // Wrap logo and greeting text inside an AnimatedOpacity widget.
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500), // Speed of the fade animation.
            opacity: _isVisible ? 1.0 : 0.0, // Fade in/out based on _isVisible.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Greeting text that uses the user's displayName or defaults to 'Explorer'.
                Text(
                  "Hello, ${user?.displayName ?? 'Learner'}!",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
