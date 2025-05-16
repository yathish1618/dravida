import 'letter_card_item.dart';
import 'mcq_question_item.dart';
import 'unknown_item.dart';

abstract class ContentItem {
  final String type;

  ContentItem(this.type);

  // Factory to parse any item type
  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final component = json['__component'] as String?;
    if (component == null) {
      return UnknownItem('unknown', json);
    }

    final type = component.split('.').last;

    switch (type) {
      case 'letter-card':
        return LetterCardItem.fromJson(json);
      case 'mcq-question':
        return McqQuestionItem.fromJson(json);
      default:
        return UnknownItem(type, json);
    }
  }
}
