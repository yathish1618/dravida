import 'package:flutter/material.dart';
import '../models/alphabet.dart';
import '../services/alphabet_service.dart';

class AlphabetQuizScreen extends StatefulWidget {
  const AlphabetQuizScreen({Key? key}) : super(key: key);

  @override
  _AlphabetQuizScreenState createState() => _AlphabetQuizScreenState();
}

class _AlphabetQuizScreenState extends State<AlphabetQuizScreen> {
  final AlphabetService _alphabetService = AlphabetService();
  List<Alphabet> _quizData = [];
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      final data = await _alphabetService.fetchAlphabets();
      setState(() {
        _quizData = data;
        print(_quizData);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _selectOption(String option) {
    if (_answered) return;
    setState(() {
      _selectedOption = option;
      _answered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % _quizData.length;
      _selectedOption = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $_error')),
      );
    }

    final question = _quizData[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Kannada Alphabets'),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              question.letter,
              style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
            ),
            Text(
              question.transliteration,
              style: const TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ...question.options.map((option) {
              final isCorrect = option == question.correctAnswer;
              final isSelected = option == _selectedOption;
              Color optionColor = Colors.grey.shade200;
              if (_answered) {
                if (isSelected) {
                  optionColor = isCorrect ? Colors.green.shade300 : Colors.red.shade300;
                } else if (isCorrect) {
                  optionColor = Colors.green.shade100;
                }
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: optionColor,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => _selectOption(option),
                  child: Text(option, style: const TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            if (_answered)
              Column(
                children: [
                  Text(
                    _selectedOption == question.correctAnswer
                        ? 'Correct! 🎉'
                        : 'Oops! Correct answer: ${question.correctAnswer}',
                    style: TextStyle(
                      fontSize: 18,
                      color: _selectedOption == question.correctAnswer ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hint: ${question.hint}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Example: ${question.exampleWord}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Next Letter'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
