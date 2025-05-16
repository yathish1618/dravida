import 'package:flutter/material.dart';

class LetterCard extends StatelessWidget {
  final String letter;
  final String audioUrl;
  final String imageUrl;

  const LetterCard({
    super.key,
    required this.letter,
    required this.audioUrl,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(letter, style: const TextStyle(fontSize: 100)),
          Image.network(imageUrl),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {/* Add audio playback */},
          ),
        ],
      ),
    );
  }
}