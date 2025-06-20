import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../services/content_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../config.dart';
import '../services/firebase_progress_service.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final ContentService _contentService = ContentService();
  final FirebaseProgressService _progressService = FirebaseProgressService();
  Map<String, dynamic> _progress = {};
  List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _fetchModules();
    _fetchProgress();
  }

  void _fetchModules() async {
    final modules = await _contentService.fetchModules();
    setState(() {
      _modules = modules;
    });
  }

  void _fetchProgress() async {
    final progress = await _progressService.fetchProgress();
    setState(() => _progress = progress);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modules"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color(0xff003366),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("$imageAssetsBasePath""$backgroundBanner"),
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
        child: _modules.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  final moduleProgress = (_progress["modules"]?[module["id"]]?["progress"] ?? 0).toDouble();
                  return _buildModuleCard(module,moduleProgress);
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module,moduleProgress) {
    
    // imagePath = module["image"];
    String? imageUrl;
    if (module["image"] != null) {
      imageUrl = module["image"]?.toString();
      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageUrl = contentAssetsBasePath + imageUrl;
      }
    }

    double progressValue = (moduleProgress ?? 0) / 100;
    int progressPercent = (progressValue * 100).toInt();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print("Module status: ${module["status"]}");
          if (module["status"] == "0") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("This module is Coming Soon"),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            Navigator.pushNamed(
              context,
              "/levels",
              arguments: {"moduleId": module["id"].toString()},
            );
          }
        },

        child: Stack(
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xfff1f0ea).withOpacity(0.95),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildScrollingText(
                            module["title"],
                            const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff627264),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildScrollingText(
                            module["description"] ?? '',
                            const TextStyle(
                              color: Color(0xff003366),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xfffe7f2d)),
                          ),
                          Text(
                            "$progressPercent%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollingText(String text, TextStyle style) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - 0; // Added buffer
        final double fontSize = style.fontSize ?? 16.0;

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();

        return textPainter.size.width > availableWidth
            ? SizedBox(
                height: fontSize + 6,
                width: availableWidth,
                child: Marquee(
                  text: text,
                  style: style,
                  scrollAxis: Axis.horizontal,
                  blankSpace: 40.0,
                  velocity: 30.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 10.0,
                ),
              )
            : SizedBox(
                width: availableWidth,
                child: Text(
                  text,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
      },
    );
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
