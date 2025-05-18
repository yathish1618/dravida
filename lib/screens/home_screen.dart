import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isVisible = true; // Controls opacity

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, "/modules"); // Ensure "/modules" is recognized
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500), // Animation speed
          opacity: _isVisible ? 1.0 : 0.0, // Fade effect
          child: Text(
            "Hello, ${user?.displayName ?? 'Explorer'}!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}