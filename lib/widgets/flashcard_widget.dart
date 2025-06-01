import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../config.dart';

class FlashcardWidget extends StatefulWidget {
  final Map<String, dynamic> flashcardData;
  final VoidCallback onComplete; // ✅

  const FlashcardWidget({
    super.key,
    required this.flashcardData,
    required this.onComplete,
  });

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showHint = false;
  String? _audioUrl;
  String? _hintAudioUrl;

  @override
  void initState() {
    super.initState();
    _setAudioUrls();
    // ✅ Notify parent that this item is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onComplete();
    });
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcardData != oldWidget.flashcardData) {
      setState(() {
        _showHint = false; // ✅ Ensure each new flashcard starts in letter view
        _setAudioUrls();
      });
    }
  }

  void _setAudioUrls() {
    _audioUrl = widget.flashcardData["audio"] != null
        ? "$contentAssetsBasePath${widget.flashcardData["audio"]}"
        : null;

    _hintAudioUrl = widget.flashcardData["hint_audio"] != null
        ? "$contentAssetsBasePath${widget.flashcardData["hint_audio"]}"
        : null;
  }

  void _playAudio() async {
    String? selectedAudio = _showHint ? _hintAudioUrl : _audioUrl;

    if (selectedAudio != null && selectedAudio.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(selectedAudio));
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

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    double cardHeight = MediaQuery.of(context).size.height * 0.7;
    double hintFontSize = MediaQuery.of(context).size.width * 0.025;

    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _showHint ? Colors.white : const Color(0xff003366),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5),
            ],
          ),
          child: Column(
            children: [
              const Text("Tap to play audio", style: TextStyle(fontSize: 14, color: Colors.grey)),

              const SizedBox(height: 10),

              // 60% - Hint Image or Letter
              Expanded(
                flex: 6,
                child: GestureDetector(
                  onTap: _playAudio, // Tap triggers audio playback for hint or letter
                  child: _showHint ? _buildHintImage() : _buildLetterDisplay(),
                ),
              ),

              // 25% - Hint Text Box (spanning full width, scrollable)
              Expanded(
                flex: 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _showHint ? 1.0 : 0.0,
                  child: _showHint
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Background spans full width
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Text.rich(
                              TextSpan(
                                text: widget.flashcardData["hint"]?.replaceAll('\\n', '\n') ?? "No hint available",
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: hintFontSize, color: Colors.grey[700]),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),

              const SizedBox(height: 10), // Padding space

              // 10% - Example/Back Button (Fixed at bottom)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: _toggleHint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff1f0ea),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(_showHint ? "Back" : "Example"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterDisplay() {
    final double fontSize = MediaQuery.of(context).size.shortestSide * 0.4;

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget.flashcardData["letter"],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  /// Shows hint image or placeholder when toggled
  Widget _buildHintImage() {
    String? hintImageUrl = widget.flashcardData["hint_image"];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300], // Placeholder background
        image: hintImageUrl != null && hintImageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage("$contentAssetsBasePath$hintImageUrl"), fit: BoxFit.contain)
            : null, // No image found, keeping blank placeholder
      ),
      child: hintImageUrl == null || hintImageUrl.isEmpty
          ? Center(child: Container(width: 100, height: 100, color: Colors.grey)) // Placeholder rectangle
          : null,
    );
  }
}
