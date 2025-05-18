import 'package:flutter/material.dart';
import '../services/strapi_service.dart';
import '../services/firebase_progress_service.dart';
import '../widgets/bottom_nav_bar.dart';

class LevelScreen extends StatefulWidget {
  final String moduleId;
  const LevelScreen({super.key, required this.moduleId});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final StrapiService _strapiService = StrapiService();
  final FirebaseProgressService _progressService = FirebaseProgressService();
  List<Map<String, dynamic>> _levels = [];
  Map<String, dynamic> _progress = {};
  String moduleId = "";


  @override
  void initState() {
    super.initState();
    _fetchLevels();
    _fetchProgress();
  }

  void _fetchLevels() async {
    final levels = await _strapiService.fetchLevels(widget.moduleId);
    levels.sort((a, b) => (a["order"] ?? 0).compareTo(b["order"] ?? 0));
    setState(() => _levels = levels);
  }

  void _fetchProgress() async {
    final progress = await _progressService.fetchProgress();
    setState(() => _progress = progress);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;  
    moduleId = args?["moduleId"] ?? ""; // Retrieve moduleId safely
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Levels")),
      body: _levels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _levels.length,
              itemBuilder: (context, index) {
                final level = _levels[index];
                final levelId = level["id"].toString();
                final unlocked = _progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["unlocked"] ?? (index == 0);
                final progress = (_progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["progress"] ?? 0).toDouble();

                return _buildLevelCard(level, unlocked, progress);
              },
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Modules tab (since levels belong to a module)
        onTap: (index) => _handleNavigation(context, index),
      ),

    );
  }

  Widget _buildLevelCard(Map<String, dynamic> level, bool unlocked, double progress) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey[300],
            color: unlocked ? Colors.blueAccent : Colors.grey,
            strokeWidth: 6,
          ),
        ),
        title: Text(level["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(level["description"]),
        trailing: unlocked ? Text("${progress.toInt()}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) : const Icon(Icons.lock, color: Colors.red),
        onTap: unlocked ? () => Navigator.pushNamed(
          context, "/items",
          arguments: {"levelId": level["id"].toString(), "moduleId": widget.moduleId},
        ) : null,
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamed(context, "/home"); // Redirect to Home
    } else if (index == 1) {
      Navigator.pushNamed(context, "/modules"); // Redirect to Modules
    } else if (index == 2) {
      Navigator.pushNamed(context, "/settings"); // Redirect to Settings
    }
  }
}