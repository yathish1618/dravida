import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/module_model.dart';
import '../models/level_model.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.0.103:1337/api';

  // Get all modules
  static Future<List<Module>> getModules() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/modules?populate[levels][populate]=items')
    );
    
    final jsonData = jsonDecode(response.body);
    return (jsonData['data'] as List).map((m) {
      // Sort levels inside each module by 'order' field before extracting IDs
      final levels = (m['levels'] as List);
      levels.sort((a, b) {
        final aOrder = a['order'] ?? 0;
        final bOrder = b['order'] ?? 0;
        return aOrder.compareTo(bOrder);
      });

      // Update the module's levels to this sorted list
      m['levels'] = levels;

      return Module.fromJson(m);
    }).toList();
  }

  // Get single level with items
  static Future<Level> getLevel(String levelId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/levels?filters[id][\$eq]=$levelId&populate=items')
    );

    final json = jsonDecode(response.body);
    return Level.fromJson(json);
  }


}