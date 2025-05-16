class Module {
  final String id;
  final String name;
  final List<String> levelIds;

  Module({required this.id, required this.name, required this.levelIds});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'].toString(),
      name: json['name'],
      levelIds: (json['levels'] as List)
          .map((level) => level['id'].toString())
          .toList(),
    );
  }
}