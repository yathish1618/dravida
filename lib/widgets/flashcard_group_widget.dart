import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../config.dart';

class FlashcardGroupWidget extends StatefulWidget {
  final Map<String, dynamic> flashcardData;
  final VoidCallback onComplete; // ✅

  const FlashcardGroupWidget({
    super.key,
    required this.flashcardData,
    required this.onComplete,
  });

  @override
  _FlashcardGroupWidgetState createState() => _FlashcardGroupWidgetState();
}

class _FlashcardGroupWidgetState extends State<FlashcardGroupWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _setAudioUrl();
    // ✅ Notify parent that this item is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onComplete();
    });
  }

  @override
  void didUpdateWidget(covariant FlashcardGroupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcardData != oldWidget.flashcardData) {
      _setAudioUrl();
    }
  }

  void _setAudioUrl() {
    _audioUrl = widget.flashcardData["audio"] != null
        ? "$contentAssetsBasePath${widget.flashcardData["audio"]}"
        : null;
  }

  void _playAudio() async {
    if (_audioUrl != null && _audioUrl!.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(_audioUrl!));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Audio not available."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    double cardHeight = MediaQuery.of(context).size.height * 0.7;

    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff003366),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5),
            ],
          ),
          child: Column(
            children: [
              const Text("Tap to play audio", style: TextStyle(fontSize: 20, color: Colors.grey)),

              const SizedBox(height: 10),

              // Letter grid area
              Expanded(
                flex: 6,
                child: GestureDetector(
                  onTap: _playAudio,
                  child: _buildLetterGrid(),
                ),
              ),

              const SizedBox(height: 10), // Padding space

              // Button area
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: _playAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff1f0ea),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Replay"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterGrid() {
    String? lettersString = widget.flashcardData["letters"];
    if (lettersString == null || lettersString.isEmpty) {
      return const Center(child: Text("No letters found", style: TextStyle(color: Colors.white)));
    }

    List<String> letters = lettersString.split("|");

    double availableWidth = MediaQuery.of(context).size.width * 0.75;
    double minTileWidth = 120;
    int crossAxisCount = (availableWidth / minTileWidth).floor().clamp(1, letters.length);


    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: letters.map((letter) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
              color: const Color(0xff003366),
            ),
          ),
        );
      }).toList(),
    );
  }
}
