import 'content_item.dart';

class LetterCardItem extends ContentItem {
  final String letter;
  final String? hint;
  final String? audio;
  final String? image;

  LetterCardItem({
    required this.letter,
    this.hint,
    this.audio,
    this.image,
  }) : super('letter-card');

  factory LetterCardItem.fromJson(Map<String, dynamic> json) {
    return LetterCardItem(
      letter: json['letter'],
      hint: json['hint'],
      audio: json['audio'],
      image: json['image'],
    );
  }
}
