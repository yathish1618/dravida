class Alphabet {
  final String letter;
  final String transliteration;
  final List<String> options;
  final String correctAnswer;
  final String hint;
  final String exampleWord;

  Alphabet({
    required this.letter,
    required this.transliteration,
    required this.options,
    required this.correctAnswer,
    required this.hint,
    required this.exampleWord,
  });

  factory Alphabet.fromJson(Map<String, dynamic> json) {
    return Alphabet(
      letter: json['letter'] ?? '',
      transliteration: json['transliteration'] ?? '',
      options: (json['options'] != null)
          ? List<String>.from(json['options'])
          : <String>[],
      correctAnswer: json['correctAnswer'] ?? '',
      hint: json['hint'] ?? '',
      exampleWord: json['exampleWord'] ?? '',
    );
  }
}
