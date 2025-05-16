import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alphabet.dart';

class AlphabetService {
  final String baseUrl = 'http://localhost:1337/api/alphabets';

  Future<List<Alphabet>> fetchAlphabets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> alphabetsJson = data['data'];

      return alphabetsJson
        .map((jsonItem) => Alphabet.fromJson(jsonItem)) // parse directly
        .toList();
    } else {
      throw Exception('Failed to load alphabets');
    }
  }

}
