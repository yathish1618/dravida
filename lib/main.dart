import 'package:flutter/material.dart';  // Add this import
import 'screens/home_screen.dart';       // Add this import

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Fix constructor syntax

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kannada Learning',
      home: HomeScreen(),
    );
  }
}