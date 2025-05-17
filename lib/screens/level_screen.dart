import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/letter_card_item.dart';
import '../models/mcq_question_item.dart';
import '../widgets/letter_card.dart';
import '../widgets/mcq_question_widget.dart';
import '../widgets/app_header.dart';
import '../widgets/ui_components.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class LevelScreen extends StatefulWidget {
  final Level level;

  const LevelScreen({super.key, required this.level});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final total = widget.level.items.length;
    final item = widget.level.items[currentIndex];

    Widget buildItemWidget() {
      if (item is LetterCardItem) {
        return LetterCard(
          letter: item.letter,
          audioUrl: item.audio ?? '',
          imageUrl: item.image ?? '',
          hint: item.hint ?? '',
        );
      } else if (item is McqQuestionItem) {
        return McqQuestionWidget(questionItem: item);
      } else {
        return const Text('Unknown item');
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            children: [
              AppHeader(showBackButton: true, title: widget.level.title),

              // 🟦 Progress bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / total,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              ),

              const SizedBox(height: 20),
              Expanded(child: buildItemWidget()),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (currentIndex < total - 1) {
                      setState(() {
                        currentIndex++;
                      });
                    } else {
                      // ✅ Completed - mark level as complete
                      print('Marking level as done: ${widget.level.id}');
                      await StorageService.markLevelCompleted(widget.level.id);
                      if (context.mounted) {
                        Navigator.pop(context); // Go back to level list
                      }
                    }
                  },
                  child: Text(currentIndex < total - 1 ? 'Continue' : 'Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
