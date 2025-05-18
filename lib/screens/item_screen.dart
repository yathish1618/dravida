import 'package:flutter/material.dart';
import '../services/strapi_service.dart';
import '../services/firebase_progress_service.dart';

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
    items.sort((a, b) => (a["order"] ?? 0).compareTo(b["order"] ?? 0));
    setState(() => _items = items);
  }

  void _nextItem() async {
    if (_currentIndex < _items.length - 1) {
      setState(() => _currentIndex++);
    } else {
      print("🔹 Last item reached. Calling updateLevelProgress...");

      await _progressService.updateLevelProgress(widget.moduleId, widget.levelId, _items.length, _items.length);

      print("✅ Firestore update should be completed. Navigating to Level Screen...");

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, "/levels", arguments: {"moduleId": widget.moduleId});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Learning Session")),
      body: Column(
        children: [
          _buildProgressIndicator(), // Always at the top
          Expanded(child: _renderItem(_items[_currentIndex])), // Centered content
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
              color: Colors.blueAccent, // Line connecting beads
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures beads are at extremes
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

  Widget _renderItem(Map<String, dynamic> item) {
    switch (item["type"]) {
      case "flashcard":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item["data"]["letter"],
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(item["data"]["hint"], style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        );
      default:
        return const Text("Unknown item type", style: TextStyle(color: Colors.red));
    }
  }
}