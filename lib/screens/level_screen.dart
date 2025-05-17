import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/letter_card_item.dart';
import '../models/mcq_question_item.dart';
import '../widgets/letter_card.dart';
import '../widgets/mcq_question_widget.dart'; // We'll create this next
import '../widgets/app_header.dart';
import '../widgets/ui_components.dart';
import '../theme/app_theme.dart';

class LevelScreen extends StatelessWidget {
  final Level level;
  
  const LevelScreen({super.key, required this.level});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App header with back button
              AppHeader(
                showBackButton: true,
                title: level.title,
              ),
              
              const SizedBox(height: 16),
              
              // Content header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Learn these letters',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondaryColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Level content
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: level.items.length,
                  itemBuilder: (context, index) {
                    final item = level.items[index];
                    
                    if (item is LetterCardItem) {
                      return LetterCard(
                        letter: item.letter,
                        audioUrl: item.audio ?? '',
                        imageUrl: item.image ?? '',
                        hint: item.hint ?? '',
                      );
                    } 
                    else if (item is McqQuestionItem) {
                      // MCQ question widget implementation
                      return McqQuestionWidget(questionItem: item);
                    }
                    // Fallback for unknown types
                    else {
                      return CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Unsupported Item Type',
                                  style: AppTheme.subheadingStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'This content type is not yet implemented in the application.',
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentColor),
                foregroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to next level or show completion dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Level completed!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Complete Level'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}