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
      appBar: AppBar(
        title: const Text("Levels"),
        backgroundColor: const Color(0xffe0ddcf),
        foregroundColor: const Color(0xff003366),
        leading: const BackButton(), // Restoring back button
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_banner.png"),
            repeat: ImageRepeat.repeat,
            scale: 2.0,
            filterQuality: FilterQuality.high,
            fit: BoxFit.none,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: _levels.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _levels.length,
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final levelId = level["id"].toString();
                  final unlocked = _progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["unlocked"] ?? (index == 0);
                  final progress = (_progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["progress"] ?? 0).toDouble();

                  return _buildLevelCard(level, unlocked, progress);
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildLevelCard(Map<String, dynamic> level, bool unlocked, double progress) {
    String type = level["type"] ?? "default";
    Color typeColor = _getTypeColor(type);
    IconData typeIcon = _getTypeIcon(type);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: typeColor,
            shape: BoxShape.circle, // Maintain circular shape but with proper color
          ),
          child: Icon(typeIcon, color: Colors.white, size: 30), // Icon overlay on color
        ),
        title: Text(
          level["title"],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(level["description"]),
        trailing: unlocked
            ? _getCompletionIcon(progress)
            : const Icon(Icons.lock, color: Colors.red),
        onTap: unlocked
            ? () => Navigator.pushNamed(
                context,
                "/items",
                arguments: {"levelId": level["id"].toString(), "moduleId": widget.moduleId},
              )
            : null,
      ),
    );
  }

  /// Determines the color based on level type
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "learn":
        return const Color(0xff003366);
      case "quiz":
        return const Color(0xfffe7f2d);
      case "practice":
        return const Color(0xffe0ddcf);
      case "checkpoint":
        return const Color(0xff627264);
      default:
        return Colors.white;
    }
  }

  /// Determines the icon based on level type
  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case "learn":
        return Icons.menu_book; // Book icon
      case "quiz":
        return Icons.help; // Question mark
      case "practice":
        return Icons.edit; // Pencil
      case "checkpoint":
        return Icons.check_circle; // Check mark
      default:
        return Icons.help_outline; // Default unknown icon
    }
  }

  /// Determines the completion icon based on progress
  Widget _getCompletionIcon(double progress) {
    if (progress >= 100) {
      return const Icon(Icons.check_circle, color: Colors.green); // Completed
    } else if (progress <= 0) {
      return const Icon(Icons.check_circle_outline, color: Colors.grey); // Not started
    } else {
      return const Icon(Icons.check_circle, color: Colors.orange); // Partial completion (optional)
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamed(context, "/home");
    } else if (index == 1) {
      Navigator.pushNamed(context, "/modules");
    } else if (index == 2) {
      Navigator.pushNamed(context, "/settings");
    }
  }
}
