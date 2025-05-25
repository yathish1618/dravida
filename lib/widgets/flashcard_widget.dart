import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FlashcardWidget extends StatefulWidget {
  final Map<String, dynamic> flashcardData;

  const FlashcardWidget({super.key, required this.flashcardData});

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showHint = false;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _setAudioUrl();
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcardData != oldWidget.flashcardData) {
      _setAudioUrl();
    }
  }

  void _setAudioUrl() {
    if (widget.flashcardData["audio"] != null && widget.flashcardData["audio"]["url"] != null) {
      _audioUrl = "https://strapi-production-2cfc.up.railway.app${widget.flashcardData["audio"]["url"]}";
      print("Audio URL Set: $_audioUrl");
    } else {
      print("Audio field missing in flashcard data");
      _audioUrl = null;
    }
  }

  void _playAudio() async {
    if (_audioUrl != null && _audioUrl!.isNotEmpty) {
      await _audioPlayer.play(UrlSource(_audioUrl!));
    } else {
      print("Audio URL is missing or invalid");
    }
  }

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.7; // ✅ Limit flashcard height
    double letterFontSize = MediaQuery.of(context).size.width * 0.25;
    double hintFontSize = MediaQuery.of(context).size.width * 0.025;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // ✅ Ensure consistent sizing
        height: cardHeight, // ✅ Define overall card height
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded( // ✅ Ensures letter fits well
              flex: 2,
              child: GestureDetector(
                onTap: _playAudio,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.flashcardData["letter"],
                    style: TextStyle(fontSize: letterFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text("Tap to play audio", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),

            if (_showHint)
              Expanded( // ✅ Dynamically adjusts hint spacing
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.flashcardData["hint"] ?? "No hint available",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(fontSize: hintFontSize, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15), // ✅ Add space below hint before the button

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4, // ✅ Keep button width manageable
              child: ElevatedButton(
                onPressed: _toggleHint,
                child: Text(_showHint ? "Back" : "Example"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}