import 'dart:convert';
import 'package:http/http.dart' as http;

class StrapiService {
  final String baseUrl = "http://192.168.0.103:1337/api";

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
    const int pageSize = 50; // Adjust based on your data size

    try {
      while (true) {
        final response = await http.get(Uri.parse("$baseUrl/levels?filters[module][id]=$moduleId&populate=*&sort=order:asc&pagination[page]=$page&pagination[pageSize]=$pageSize"));
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<Map<String, dynamic>> levels = List<Map<String, dynamic>>.from(data["data"]);
          
          if (levels.isEmpty) break; // Stop if no more data

          allLevels.addAll(levels);
          page++; // Go to the next page
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
}