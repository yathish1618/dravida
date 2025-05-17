import 'content_item.dart';

class UnknownItem extends ContentItem {
  final Map<String, dynamic> raw;

  UnknownItem(super.type, this.raw);
}
