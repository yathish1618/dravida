import 'package:flutter/material.dart';
import '../services/content_service.dart';
import '../services/firebase_progress_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../config.dart';

class LevelScreen extends StatefulWidget {
  final String moduleId;
  const LevelScreen({super.key, required this.moduleId});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final ContentService _contentService = ContentService();
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
    final levels = await _contentService.fetchLevels(widget.moduleId);
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
    moduleId = args?["moduleId"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Levels"),
        centerTitle: true, // 👈 This centers the title
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, "/modules"),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("$imageAssetsBasePath" "$backgroundBanner"),
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
              ? const SizedBox(height: 400, child: Center(child: CircularProgressIndicator()))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth > 700 ? 700 : constraints.maxWidth;
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          itemCount: _levels.length,
                          itemBuilder: (context, index) {
                            final level = _levels[index];
                            final levelId = level["id"].toString();
                            final unlocked = _progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["unlocked"] ?? (index == 0);
                            final progress = (_progress["modules"]?[widget.moduleId]?["levels"]?[levelId]?["progress"] ?? 0).toDouble();
                            return _buildTimelineTile(level, unlocked, progress, index, _levels.length);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildTimelineTile(
    Map<String, dynamic> level,
    bool unlocked,
    double progress,
    int index,
    int total,
  ) {
    String type = level["level_type"] ?? "default";
    Color typeColor = _getTypeColor(type);
    IconData typeIcon = _getTypeIcon(type);

    final isFirst = index == 0;
    final isLast = index == total - 1;
    final lastCompleted = progress >= 100;

    return Stack(
      children: [
        // Main vertical spine behind everything
        Positioned(
          left: 23,
          top: isFirst ? (46 / 2 + 25) : 0,
          bottom: isLast ? (46 / 2 + 15) : 0,
          child: Container(
            width: 4,
            color: Colors.grey.shade300,
          ),
        ),

        Column(
          children: [
            // Start Icon (only before first tile)
            if (index == 0)
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 140,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade600,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.rocket_launch, color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Timeline circle (slightly lifted)
                Container(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: const Offset(0, -15),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: unlocked ? typeColor : Colors.grey.shade400,
                        shape: BoxShape.circle,
                        boxShadow: unlocked
                            ? [
                                BoxShadow(
                                  color: typeColor.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(typeIcon, color: Colors.white, size: 26),
                    ),
                  ),
                ),

                // Horizontal connector to card
                const SizedBox(width: 0),
                Transform.translate(
                  offset: const Offset(0, -14), // move up by 6 pixels
                  child: Container(
                    width: 16,
                    height: 4,
                    color: Colors.grey.shade300,
                  ),
                ),

                const SizedBox(width: 0),

                // Level card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!unlocked) return;
                      if (level["status"].toString() == "0") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("This level is Coming Soon"),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          "/items",
                          arguments: {
                            "levelId": level["id"].toString(),
                            "moduleId": widget.moduleId,
                            "levelTitle": level["title"].toString(),
                          },
                        );
                      }
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 30),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: typeColor, width: 10)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start, // Important!
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        level["title"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        level["description"] ?? "",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        type.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: typeColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 80, // Matches approximate card content height
                                  child: unlocked
                                      ? Icon(
                                          progress >= 100 ? Icons.check_circle : Icons.check_circle_outline,
                                          color: progress >= 100 ? Colors.green : const Color.fromARGB(255, 59, 59, 59),
                                          size: 25, // Slightly larger for better card alignment
                                        )
                                      : const Icon(Icons.lock, color: Colors.red, size: 25),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // End Trophy (only after last tile)
            if (isLast)
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lastCompleted
                            ? Colors.green.shade600
                            : Colors.grey.shade400,
                        boxShadow: [
                          if (lastCompleted)
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }


  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "learn":
        return const Color.fromARGB(255, 255, 0, 85);
      case "quiz":
        return const Color.fromARGB(255, 162, 0, 255);
      case "practice":
        return const Color.fromARGB(255, 32, 71, 71);
      case "checkpoint":
        return const Color(0xff627264);
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case "learn":
        return Icons.menu_book;
      case "quiz":
        return Icons.help;
      case "practice":
        return Icons.edit;
      case "checkpoint":
        return Icons.check_circle;
      default:
        return Icons.help_outline;
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