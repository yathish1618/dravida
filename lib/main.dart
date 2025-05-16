import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'alphabet_quiz_screen.dart';

void main() {
  runApp(const DravidaApp());
}

class DravidaApp extends StatelessWidget {
  const DravidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dravida',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFC107),
        fontFamily: 'NotoSerifKannada', // Add this font later
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/alphabetModule': (context) => const AlphabetQuizScreen(),
        // Add other routes here later
      },
    );
  }
}
