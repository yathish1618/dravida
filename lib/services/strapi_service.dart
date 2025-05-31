import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class StrapiService {
  final String baseUrl = kApiUrl;

  // Fetch Modules
  Future<List<Map<String, dynamic>>> fetchModules() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/modules?populate=*"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        throw Exception("Failed to fetch modules");
      }
    } catch (e) {
      print("Error fetching modules: $e");
      return [];
    }
  }

  // ✅ Fetch Levels for a Specific Module
  Future<List<Map<String, dynamic>>> fetchLevels(String moduleId) async {
    List<Map<String, dynamic>> allLevels = [];
    int page = 1;
    const int pageSize = 50;

    try {
      while (true) {
        final response = await http.get(Uri.parse("$baseUrl/levels?filters[module][id]=$moduleId&populate=*&sort=order:asc&pagination[page]=$page&pagination[pageSize]=$pageSize"));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<Map<String, dynamic>> levels = List<Map<String, dynamic>>.from(data["data"]);
          if (levels.isEmpty) break;
          allLevels.addAll(levels);
          page++;
        } else {
          throw Exception("Failed to fetch levels");
        }
      }
    } catch (e) {
      print("❌ Error fetching all levels: $e");
    }

    return allLevels;
  }

  // ✅ Fetch Items for a Specific Level
  Future<List<Map<String, dynamic>>> fetchItems(String levelId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/level-item-links?filters[level][id]=$levelId&populate=*"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["data"].map<Map<String, dynamic>>((item) {
          return {
            "id": item["id"],
            "order": item["order"],
            "type": item.containsKey("item_flashcard") ? "flashcard" : "unknown",
            "data": item["item_flashcard"] ?? {},
          };
        }).toList();
      } else {
        throw Exception("Failed to fetch items");
      }
    } catch (e) {
      print("Error fetching items: $e");
      return [];
    }
  }

  // ✅ Fetch Flashcards With Populated Audio
  Future<List<Map<String, dynamic>>> fetchFlashcardsWithAudio() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/item-flashcards?populate=audio"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        throw Exception("Failed to fetch flashcards with audio");
      }
    } catch (e) {
      print("❌ Error fetching flashcard audio: $e");
      return [];
    }
  }
}