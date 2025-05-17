import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static const String _userIdKey = 'user_id';
  static const String _completedLevelsKeyPrefix = 'completed_levels_';

  // Get or generate a user ID
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);

    if (userId == null || userId.isEmpty) {
      userId = const Uuid().v4();
      await prefs.setString(_userIdKey, userId);
    }

    return userId;
  }

  // Mark a level as completed for this user
  static Future<void> markLevelCompleted(String levelId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await getUserId();
    final key = '$_completedLevelsKeyPrefix$userId';
    final completedLevels = prefs.getStringList(key) ?? [];

    if (!completedLevels.contains(levelId)) {
      completedLevels.add(levelId);
      await prefs.setStringList(key, completedLevels);
    }
  }

  // Get completed levels for this user
  static Future<List<String>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await getUserId();
    final key = '$_completedLevelsKeyPrefix$userId';
    return prefs.getStringList(key) ?? [];
  }
}
