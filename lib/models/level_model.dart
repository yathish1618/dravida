import 'content_item.dart';
import 'unknown_item.dart';

class Level {
  final String id;
  final String title;
  final int order; // Added this line
  final List<ContentItem> items;

  Level({
    required this.id,
    required this.title,
    required this.order, // Added this line
    required this.items,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    final levelData = json['data'][0];

    final itemsJson = levelData['items'] as List<dynamic>? ?? [];

    final items = itemsJson.map((itemJson) {
      try {
        final parsed = ContentItem.fromJson(itemJson);
        return parsed;
      } catch (e) {
        return UnknownItem(itemJson['__component'] ?? 'unknown', itemJson);
      }
    }).toList();


    return Level(
      id: levelData['id'].toString(),
      title: levelData['title'] ?? 'Untitled',
      order: levelData['order'] ?? 0, // Added this line
      items: items,
    );
  }
}
