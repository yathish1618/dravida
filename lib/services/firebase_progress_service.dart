import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'strapi_service.dart';

class FirebaseProgressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final StrapiService _strapiService = StrapiService(); // Use existing Strapi service

  // Fetch User Progress
  Future<Map<String, dynamic>> fetchProgress() async {
    if (_user == null) return {};
    final doc = await _db.collection("user_progress").doc(_user.uid).get();
    return doc.exists ? doc.data() ?? {} : {};
  }

  // ✅ Update User Progress and Unlock Next Level
  Future<void> updateLevelProgress(String moduleId, String levelId, int itemsCompleted, int totalItems) async {
    if (_user == null) {
      print("❌ User is null. Cannot update progress.");
      return;
    }

    final progress = (itemsCompleted.toDouble() / totalItems.toDouble()) * 100;
    print("🔹 Updating Firestore: Module ID: $moduleId, Level ID: $levelId");

    // 🔹 Fetch Levels from Strapi
    final List<Map<String, dynamic>> levelDocs = await _strapiService.fetchLevels(moduleId);

    // 🔹 Get current level order
    final Map<String, dynamic> currentLevel = levelDocs.firstWhere(
      (l) => l["id"].toString() == levelId,
      orElse: () => {}
    );
    final int currentOrder = currentLevel["order"] ?? 0;

    // 🔍 Find the next level based on order
    Map<String, dynamic>? nextLevel;
    for (final level in levelDocs) {
      if ((level["order"] ?? 0) > currentOrder) { // Now we compare properly
        nextLevel = level;
        break;
      }
    }


    // ✅ Store progress for completed level
    await _db.collection("user_progress").doc(_user.uid).set({
      "modules": {
        moduleId: {
          "levels": {
            levelId: {
              "itemsCompleted": itemsCompleted,
              "totalItems": totalItems,
              "progress": progress,
              "unlocked": progress >= 100,
            }
          }
        }
      }
    }, SetOptions(merge: true));

    // ✅ Unlock next level if found
    if (progress >= 100 && nextLevel != null) {
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


  // Generate progress report
  Future<Map<String, dynamic>> generateProgressReport() async {
    if (_user == null) return {};
    final doc = await _db.collection("user_progress").doc(_user.uid).get();
    if (!doc.exists) return {};

    final data = doc.data() ?? {};
    int totalLevels = 0, unlockedLevels = 0, totalItems = 0, completedItems = 0;

    data["modules"]?.forEach((moduleId, moduleData) {
      moduleData["levels"]?.forEach((levelId, levelData) {
        totalLevels++;
        if (levelData["unlocked"] == true) unlockedLevels++;
        int totalItemsCount = (levelData["totalItems"] ?? 0).toInt();
        int completedItemsCount = (levelData["itemsCompleted"] ?? 0).toInt();

        totalItems += totalItemsCount;
        completedItems += completedItemsCount;
      });
    });

    return {
      "totalLevels": totalLevels,
      "unlockedLevels": unlockedLevels,
      "totalItems": totalItems,
      "completedItems": completedItems,
      "overallProgress": totalItems > 0 ? ((completedItems.toDouble() / totalItems.toDouble()) * 100) : 0.0,
    };
  }
}