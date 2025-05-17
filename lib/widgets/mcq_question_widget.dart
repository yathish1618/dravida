import 'package:flutter/material.dart';
import '../models/mcq_question_item.dart';
import '../theme/app_theme.dart';

class McqQuestionWidget extends StatefulWidget {
  final McqQuestionItem questionItem;
  
  const McqQuestionWidget({super.key, required this.questionItem});

  @override
  State<McqQuestionWidget> createState() => _McqQuestionWidgetState();
}

class _McqQuestionWidgetState extends State<McqQuestionWidget> {
  int? selectedOption;
  bool hasSubmitted = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.quiz,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Multiple Choice Question',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Question text
              Text(
                widget.questionItem.question,
                style: AppTheme.subheadingStyle.copyWith(fontSize: 18),
              ),
              
              const SizedBox(height: 16),
              
              // Options
              ...List.generate(widget.questionItem.options.length, (index) {
                bool isCorrect = index == widget.questionItem.correctIndex;
                bool isSelected = selectedOption == index;
                
                Color borderColor = Colors.grey.withOpacity(0.3);
                Color bgColor = Colors.transparent;
                
                if (hasSubmitted && isSelected) {
                  borderColor = isCorrect ? Colors.green : Colors.red;
                  bgColor = isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1);
                } else if (isSelected) {
                  borderColor = AppTheme.primaryColor;
                  bgColor = AppTheme.primaryColor.withOpacity(0.05);
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: hasSubmitted ? null : () {
                      setState(() {
                        selectedOption = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: bgColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryColor : Colors.grey,
                                width: 2,
                              ),
                              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.questionItem.options[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected && hasSubmitted
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : AppTheme.textPrimaryColor,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (hasSubmitted) ...[
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red.withOpacity(0.5),
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 8),
              
              // Submit button
              if (!hasSubmitted) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: selectedOption != null
                        ? () {
                            setState(() {
                              hasSubmitted = true;
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Check Answer'),
                  ),
                ),
              ],
              
              // Feedback when submitted
              if (hasSubmitted) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedOption == widget.questionItem.correctIndex
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedOption == widget.questionItem.correctIndex
                          ? Colors.green
                          : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedOption == widget.questionItem.correctIndex
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: selectedOption == widget.questionItem.correctIndex
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedOption == widget.questionItem.correctIndex
                                  ? 'Correct!'
                                  : 'Incorrect',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selectedOption == widget.questionItem.correctIndex
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            if (selectedOption != widget.questionItem.correctIndex) ...[
                              const SizedBox(height: 4),
                              Text(
                                'The correct answer is: ${widget.questionItem.options[widget.questionItem.correctIndex]}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Try again button if wrong
                if (selectedOption != widget.questionItem.correctIndex) ...[
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          hasSubmitted = false;
                          selectedOption = null;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.accentColor,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}