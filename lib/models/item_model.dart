class ContentItem {
  final String type;
  final Map<String, dynamic> data;

  ContentItem({required this.type, required this.data});

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      type: json['__component'].split('.').last, // Gets 'letter-card' from 'level-items.letter-card'
      data: json,
    );
  }
}