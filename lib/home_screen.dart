import 'package:flutter/material.dart';

// Define your color scheme
const Color primaryColor = Color(0xFFFFC107);  // Mysore Yellow
const Color secondaryColor = Color(0xFF800000); // Deep Maroon
const Color accentColor = Color(0xFF4CAF50);    // Peepal Leaf Green
const Color backgroundColor = Color(0xFFFFF8E1); // Cream
const Color textColor = Color(0xFF212121);       // Dark Charcoal

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // List of modules - add more modules here later
  final List<Map<String, dynamic>> modules = const [
    {
      'title': 'Learn Kannada Alphabets',
      'icon': Icons.language,
      'color': primaryColor,
      'route': '/alphabetModule',
    },
    {
      'title': 'Basic Phrases',
      'icon': Icons.chat_bubble_outline,
      'color': secondaryColor,
      'route': '/basicPhrases', // Placeholder route
    },
    // Add more modules here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Dravida',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: modules.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 tiles per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, module['route']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: module['color'],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      module['icon'],
                      size: 48,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      module['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
