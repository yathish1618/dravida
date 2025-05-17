import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart'; // Import our new theme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dravida - Learn Kannada',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: AppTheme.getThemeData(), // Use our custom theme
      home: const HomeScreen(),
    );
  }
}