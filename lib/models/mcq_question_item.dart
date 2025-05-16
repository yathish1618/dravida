import 'content_item.dart';

class McqQuestionItem extends ContentItem {
  final String question;
  final List<String> options;
  final int correctIndex;

  McqQuestionItem({
    required this.question,
    required this.options,
    required this.correctIndex,
  }) : super('mcq-question');

  factory McqQuestionItem.fromJson(Map<String, dynamic> json) {
    return McqQuestionItem(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }
}
