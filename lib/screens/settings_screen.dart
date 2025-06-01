import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/firebase_progress_service.dart';

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
              onPressed: () => _showConfirmationDialog(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear All Data", style: TextStyle(color: Colors.white)),
            ),

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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Progress"),
          content: const Text("Are you sure you want to reset all of your progress data?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel action
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _clearProgressData(context);
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _clearProgressData(BuildContext context) async {
    try {
      await FirebaseProgressService().clearProgressData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Progress data cleared successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error clearing data: $e")),
      );
    }
  }

}