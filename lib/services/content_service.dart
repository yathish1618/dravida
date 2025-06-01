import 'package:supabase_flutter/supabase_flutter.dart';

class ContentService {
    final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchModules() async {
    final response = await supabase.rpc('fetch_modules');

    if (response == null) {
      throw Exception("❌ No data returned from fetch_modules RPC.");
    }

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception("❌ Unexpected response format: $response");
    }
  }

  Future<List<Map<String, dynamic>>> fetchLevels(String moduleId) async {
    final response = await supabase.rpc('fetch_levels', params: {"module_id": moduleId});

    if (response == null) {
      throw Exception("❌ No data returned from fetch_levels RPC.");
    }

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception("❌ Unexpected response format: $response");
    }
  }

  Future<List<Map<String, dynamic>>> fetchItems(String levelId) async {
    final response = await supabase.rpc('fetch_items', params: {"level_id": levelId});

    if (response == null) {
      throw Exception("❌ No data returned from fetch_levels RPC.");
    }

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception("❌ Unexpected response format: $response");
    }
  }

  Future<Map<String, dynamic>?> fetchNextLevel(String moduleId, String levelId) async {
    final response = await supabase.rpc('fetch_next_level', params: {"module_id": moduleId, "level_id": levelId});

    if (response == null) {
      return null; // No next level found
    }

    if (response is List) {
      return response.isNotEmpty ? response.first as Map<String, dynamic> : null;
    } else {
      throw Exception("❌ Unexpected response format: $response");
    }
  }

}