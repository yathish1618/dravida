import 'package:flutter/material.dart';
import '../services/content_service.dart';
import '../services/firebase_progress_service.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/flashcard_group_widget.dart';
import '../widgets/mcqs_widget.dart';
import '../config.dart';

class ItemScreen extends StatefulWidget {
  final String levelId;
  final String moduleId;
  const ItemScreen({super.key, required this.levelId, required this.moduleId});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
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
        _isCurrentItemCompleted = false; // 👈 Reset here
      });
    } else {
      await _progressService.updateLevelProgress(widget.moduleId, widget.levelId, _items.length);
      Navigator.pushReplacementNamed(context, "/levels", arguments: {"moduleId": widget.moduleId});
    }
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
          onPressed: _confirmExit,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _confirmExit,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("$imageAssetsBasePath""welcome_banner.png"),
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
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _buildItemWidget(_items[_currentIndex]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: _isCurrentItemCompleted ? _nextItem : null, // ❌ disables if not done,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffe7f2d),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isCurrentItemCompleted = false;

  void _onItemCompleted() {
    setState(() {
      _isCurrentItemCompleted = true;
    });
  }


  Widget _buildItemWidget(Map<String, dynamic> item) {
    final itemType = item["item_type"];
    final metadata = item["item_metadata"];

    switch (itemType) {
      case "flashcard":
        return FlashcardWidget(
          key: ValueKey<int>(_currentIndex),
          flashcardData: metadata,
          onComplete: _onItemCompleted, // ✅
        );
      case "flashcard_group":
        return FlashcardGroupWidget(
          key: ValueKey<int>(_currentIndex),
          flashcardData: metadata,
          onComplete: _onItemCompleted, // ✅
        );
      case "mcq":
        return MCQsWidget(
          key: ValueKey<int>(_currentIndex),
          mcqData: metadata,
          onComplete: _onItemCompleted, // ✅
        );
      default:
        return Center(
          key: ValueKey<int>(_currentIndex),
          child: const Text("Unsupported item type"),
        );
    }
  }

  /// Animated progress bar
  Widget _buildProgressIndicator() {
    double screenWidth = MediaQuery.of(context).size.width * 0.9; 
    int totalItems = _items.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalItems, (index) {
              return Expanded(
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

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Learning Session"),
          content: const Text("Are you sure you want to exit? Current progress within the level will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/levels", arguments: {"moduleId": widget.moduleId});
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}