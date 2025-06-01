import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/firebase_progress_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final bool isAnonymous = user?.isAnonymous ?? true;

    final String displayName =
        (user?.displayName?.trim().isNotEmpty ?? false) ? user!.displayName! : "Guest User";
    final String email = isAnonymous ? "Anonymous" : (user?.email ?? "Unknown");

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xffe0ddcf),
        foregroundColor: const Color(0xff003366),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Account
            Text("Account", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Name: $displayName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),

            // Section: Actions
            Text("Actions", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Buttons with icons
            _buildSettingsButton(
              context: context,
              icon: Icons.delete_forever,
              text: "Clear All Data",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () => _showConfirmationDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingsButton(
              context: context,
              icon: Icons.logout,
              text: "Log Out",
              backgroundColor: colorScheme.secondaryContainer,
              textColor: colorScheme.onSecondaryContainer,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildSettingsButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _clearProgressData(context);
                Navigator.pop(context);
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
