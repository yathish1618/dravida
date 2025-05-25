import 'package:flutter/material.dart';
import '../services/strapi_service.dart';
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
  final StrapiService _strapiService = StrapiService();
  final FirebaseProgressService _progressService = FirebaseProgressService();
  
  List<Map<String, dynamic>> _items = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final items = await _strapiService.fetchItems(widget.levelId);
    final flashcards = await _strapiService.fetchFlashcardsWithAudio();

    items.sort((a, b) => (a["order"] ?? 0).compareTo(b["order"] ?? 0));

    for (var item in items) {
      if (item["type"] == "flashcard") {
        final flashcard = flashcards.firstWhere(
          (fc) => fc["letter"] == item["data"]["letter"],
          orElse: () => {},
        );
        item["data"]["audio"] = flashcard["audio"];  // ✅ Correctly assign audio
      }
    }

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
      await _progressService.updateLevelProgress(widget.moduleId, widget.levelId, _items.length, _items.length);
      Navigator.pushReplacementNamed(context, "/levels", arguments: {"moduleId": widget.moduleId});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Learning Session")),
      body: Column(
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
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.blueAccent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_items.length, (index) {
                return Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= _currentIndex ? Colors.blue : Colors.grey[300],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ Dynamically handle multiple item types
  Widget _renderItem(Map<String, dynamic> item) {
    switch (item["type"]) {
      case "flashcard":
        return FlashcardWidget(flashcardData: item["data"]);
      default:
        return const Text("Unknown item type", style: TextStyle(color: Colors.red));
    }
  }
}