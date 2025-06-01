import 'package:flutter/material.dart';
// import '../services/strapi_service.dart';
import '../services/content_service.dart';
import '../services/firebase_progress_service.dart';
import '../widgets/flashcard_widget.dart';

class ItemScreen extends StatefulWidget {
  final String levelId;
  final String moduleId;
  const ItemScreen({super.key, required this.levelId, required this.moduleId});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  // final StrapiService _strapiService = StrapiService();
  final ContentService _contentService = ContentService();
  final FirebaseProgressService _progressService = FirebaseProgressService();
  
  List<Map<String, dynamic>> _items = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final items = await _contentService.fetchItems(widget.levelId);
    setState(() {
      _items = items;
    });
  }

  void _nextItem() async {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      await _progressService.updateLevelProgress(widget.moduleId, widget.levelId, _items.length);
      Navigator.pushReplacementNamed(context, "/levels", arguments: {"moduleId": widget.moduleId});
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Learning Session"),
          content: const Text("Are you sure you want to exit? Current progress within the level will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context, "/levels",
                  arguments: {"moduleId": widget.moduleId}, // Navigate back to LevelScreen
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Session"),
        backgroundColor: const Color(0xffe0ddcf),
        foregroundColor: const Color(0xff003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _confirmExit, // Confirmation popup before going back
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit, // Cross button also triggers exit confirmation
          ),
        ],
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
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(child: _renderItem(_items[_currentIndex])),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _nextItem,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Redesigned progress bar with step indicators
  Widget _buildProgressIndicator() {
    double screenWidth = MediaQuery.of(context).size.width * 0.9; // 90% screen width
    int totalItems = _items.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: screenWidth, // Total width spans 90% of screen
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Even spacing across width
            children: List.generate(totalItems, (index) {
              return Expanded( // Forces each segment to proportionally adjust
                child: Container(
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: index <= _currentIndex ? const Color(0xfffe7f2d) : Colors.grey[300],
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? const Radius.circular(6) : Radius.zero,
                      right: index == totalItems - 1 ? const Radius.circular(6) : Radius.zero,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _renderItem(Map<String, dynamic> item) {
    switch (item["item_type"]) {
      case "flashcard":
        return FlashcardWidget(flashcardData: item["item_metadata"]);
      default:
        return const Text("Unknown item type", style: TextStyle(color: Colors.red));
    }
  }
}
