import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../config.dart';

class MCQsWidget extends StatefulWidget {
  final Map<String, dynamic> mcqData;
  final VoidCallback onComplete;

  const MCQsWidget({super.key, required this.mcqData, required this.onComplete});

  @override
  State<MCQsWidget> createState() => _MCQsWidgetState();
}

class _MCQsWidgetState extends State<MCQsWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late List<OptionItem> _options;
  int? _selectedIndex;
  List<int> _correctIndices = [];
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _prepareOptions();
  }

  void _prepareOptions() {
    final data = widget.mcqData;
    final n = int.tryParse(data['n_options'].toString()) ?? 0;
    final shuffle = data['shuffle_options']?.toString() == '1';
    final correct = data['correct_options']?.split('|').map((e) => int.parse(e.trim()) - 1).toList() ?? [];

    List<OptionItem> options = [];

    for (int i = 0; i < n; i++) {
      options.add(
        OptionItem(
          index: i,
          value: data['option${i + 1}'],
          hint: data['option${i + 1}_hint'],
        ),
      );
    }

    if (shuffle) {
      options.shuffle(Random());
    }

    setState(() {
      _options = options;
      _correctIndices = correct.cast<int>();
    });
  }

  void _playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource('$contentAssetsBasePath$url'));
    } catch (_) {}
  }

  void _handleOptionTap(int index) {
    if (_answered) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSubmit() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option before submitting.')),
      );
      return;
    }

    setState(() {
      _answered = true;
    });

    widget.onComplete(); // ✅ Notify parent to enable outer "Continue"
  }

  bool _isCorrect(int index) {
    final actualIndex = _options[index].index;
    return _correctIndices.contains(actualIndex);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.mcqData;
    final qstemType = data['qstem_type'];
    final optionsType = data['options_type'];

    double cardWidth = MediaQuery.of(context).size.width * 0.85;
    double cardHeight = MediaQuery.of(context).size.height * 0.7;

    return Center(
      child: Container(
        width: cardWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xfffdfdfd),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5),
          ],
        ),
        child: Column(
          children: [
            // Instruction
            SizedBox(
              height: cardHeight * 0.2,
              child: Center(
                child: Text(
                  data['instruction'] ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Qstem
            SizedBox(
              height: cardHeight * 0.4,
              child: Center(child: _buildQstem(data['qstem'], qstemType)),
            ),

            const SizedBox(height: 10),

            // Options
            Expanded(
              child: ListView.separated(
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final item = _options[index];
                  final selected = _selectedIndex == index;
                  final isCorrect = _isCorrect(index);

                  Color bgColor;
                  if (!_answered) {
                    bgColor = selected ? Colors.blue.shade100 : Colors.white;
                  } else {
                    if (selected && isCorrect) {
                      bgColor = Colors.green.shade200;
                    } else if (selected && !isCorrect) {
                      bgColor = Colors.red.shade200;
                    } else if (isCorrect) {
                      bgColor = Colors.green.shade100;
                    } else {
                      bgColor = Colors.white;
                    }
                  }

                  return GestureDetector(
                    onTap: () => _handleOptionTap(index),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildOption(item.value, optionsType)),
                          if (item.hint != null && item.hint!.isNotEmpty)
                            Tooltip(
                              message: item.hint!,
                              child: const Icon(Icons.info_outline, size: 18),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ),

            const SizedBox(height: 10),

            // Submit Button (hide after answer is shown)
            if (!_answered)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfffe7f2d),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Submit"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQstem(String? content, String? type) {
    if (content == null || content.isEmpty) {
      return const Text("No question stem provided.");
    }

    switch (type) {
      case "text":
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case "image":
        return Image.network(
          '$contentAssetsBasePath$content',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );

      case "audio":
        return IconButton(
          icon: const Icon(Icons.volume_up, size: 40),
          onPressed: () => _playAudio(content),
        );

      default:
        return const Text("Unsupported qstem type.");
    }
  }

  Widget _buildOption(String? content, String? type) {
    if (content == null || content.isEmpty) return const Text("N/A");

    switch (type) {
      case "text":
        return Text(content, style: const TextStyle(fontSize: 16));
      case "image":
        return Image.network(
          '$contentAssetsBasePath$content',
          height: 40,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      case "audio":
        return IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () => _playAudio(content),
        );
      default:
        return const Text("Unsupported");
    }
  }
}

class OptionItem {
  final int index;
  final String? value;
  final String? hint;

  OptionItem({
    required this.index,
    this.value,
    this.hint,
  });
}
