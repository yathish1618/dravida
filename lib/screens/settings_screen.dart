import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user?.displayName ?? 'Unknown'}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Email: ${user?.email ?? 'Unknown'}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Settings tab
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamed(context, "/home");
    } else if (index == 1) {
      Navigator.pushNamed(context, "/modules");
    } else if (index == 2) {
      Navigator.pushNamed(context, "/settings");
    }
  }
}