import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/content_service.dart';

class FirebaseProgressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final ContentService _contentService = ContentService();

  // Fetch User Progress
  Future<Map<String, dynamic>> fetchProgress() async {
    if (_user == null) return {};
    final doc = await _db.collection("user_progress").doc(_user.uid).get();
    return doc.exists ? doc.data() ?? {} : {};
  }

  // ✅ Update User Progress and Unlock Next Level
  Future<void> updateLevelProgress(String moduleId, String levelId, int totalItems) async {
    if (_user == null) {
      print("❌ User is null. Cannot update progress.");
      return;
    }

    print("🔹 Updating Firestore: Module ID: $moduleId, Level ID: $levelId");

    // ✅ Fetch all levels for the module to determine totalLevels
    final levels = await _contentService.fetchLevels(moduleId);
    final int totalLevels = levels.length;

    // ✅ Fetch user's current progress data
    final progressData = await fetchProgress();
    final moduleProgress = progressData["modules"]?[moduleId]?["levels"] ?? {};

    // ✅ Count levels that are unlocked
    int levelsCompleted = moduleProgress.entries.where((entry) => entry.value["unlocked"] == true).length;

    // ✅ Calculate overall progress (rounded percentage)
    final int moduleProgressPercentage = (levelsCompleted / totalLevels * 100).round();

    // ✅ Store progress for completed level and update module progress
    await _db.collection("user_progress").doc(_user.uid).set({
      "modules": {
        moduleId: {
          "levels": {
            levelId: {
              "totalItems": totalItems,
              "progress": 100,
              "unlocked": true,
            }
          },
          "totalLevels": totalLevels,
          "levelsCompleted": levelsCompleted,
          "progress": moduleProgressPercentage, // Rounded percentage
        }
      }
    }, SetOptions(merge: true));

    print("✅ Progress updated: $levelsCompleted / $totalLevels levels completed ($moduleProgressPercentage%)");

    // ✅ Fetch the next level for unlocking
    final nextLevel = await _contentService.fetchNextLevel(moduleId, levelId);

    // ✅ Unlock next level if found
    if (nextLevel != null) {
      final nextLevelId = nextLevel["id"].toString();
      print("🔹 Unlocking next level: $nextLevelId");

      await _db.collection("user_progress").doc(_user.uid).set({
        "modules": {
          moduleId: {
            "levels": {
              nextLevelId: {
                "unlocked": true, // Ensure level is marked as unlocked
              }
            }
          }
        }
      }, SetOptions(merge: true));

      print("✅ Next level unlocked!");
    }
  }

  Future<int> fetchLevelProgress(String levelId) async {
    if (_user == null) {
      print("❌ User is null. Cannot fetch level progress.");
      return 0;
    }

    final progressData = await fetchProgress();
    final modules = progressData["modules"] ?? {};

    for (var moduleEntry in modules.entries) {
      final levels = moduleEntry.value["levels"] ?? {};
      if (levels.containsKey(levelId)) {
        return (levels[levelId]["progress"] ?? 0).toInt();
      }
    }

    return 0; // Level not found or no progress data
  }

  Future<int> fetchModuleProgress(String moduleId) async {
    if (_user == null) {
      print("❌ User is null. Cannot fetch module progress.");
      return 0;
    }

    final progressData = await fetchProgress();
    final moduleProgress = progressData["modules"]?[moduleId] ?? {};

    return (moduleProgress["progress"] ?? 0).toInt(); // Return module progress percentage
  }


  // ✅ Clear All User Progress
  Future<void> clearProgressData() async {
    if (_user == null) {
      print("❌ User is null. Cannot clear progress.");
      return;
    }

    try {
      await _db.collection("user_progress").doc(_user.uid).delete();
      print("✅ User progress data cleared successfully!");
    } catch (e) {
      print("❌ Error clearing progress data: $e");
    }
  }

}