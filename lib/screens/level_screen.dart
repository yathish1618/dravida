import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/letter_card_item.dart';
import '../models/mcq_question_item.dart'; // If you create one
import '../widgets/letter_card.dart';
// import '../widgets/mcq_question_widget.dart'; // Optional future widget

class LevelScreen extends StatelessWidget {
  final Level level;

  const LevelScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(level.title)),
      body: ListView.builder(
        itemCount: level.items.length,
        itemBuilder: (context, index) {
          final item = level.items[index];

          if (item is LetterCardItem) {
            return LetterCard(
              letter: item.letter,
              audioUrl: item.audio ?? '',
              imageUrl: item.image ?? '',
            );
          }

          // Add support for other item types
          else if (item is McqQuestionItem) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('MCQ: ${item.question}'), // Placeholder
              // return McqQuestionWidget(questionItem: item); <-- future widget
            );
          }

          // Fallback for unknown or unhandled types
          else {
            return const ListTile(
              title: Text('Unsupported item type'),
              subtitle: Text('This item type is not yet implemented.'),
            );
          }
        },
      ),
    );
  }
}
