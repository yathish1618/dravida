import 'content_item.dart';

class UnknownItem extends ContentItem {
  final Map<String, dynamic> raw;

  UnknownItem(String type, this.raw) : super(type);
}
