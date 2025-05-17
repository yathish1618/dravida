import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../screens/level_screen.dart';

class LevelList extends StatefulWidget {
  final List<String> levelIds;

  const LevelList({super.key, required this.levelIds});

  @override
  State<LevelList> createState() => _LevelListState();
}

class _LevelListState extends State<LevelList> {
  List<String> completedLevelIds = [];

  @override
  void initState() {
    super.initState();
    loadCompletedLevels();
  }

  Future<void> loadCompletedLevels() async {
    final completed = await StorageService.getCompletedLevels();
    setState(() {
      completedLevelIds = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.levelIds.length,
      itemBuilder: (context, index) {
        final levelId = widget.levelIds[index];
        final isCompleted = completedLevelIds.contains(levelId);
        final isLocked = index > 0 && !completedLevelIds.contains(widget.levelIds[index - 1]);

        return FutureBuilder<Level>(
          future: ApiService.getLevel(levelId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const ListTile(title: Text('Loading...'));
            final level = snapshot.data!;

            return Card(
              child: ListTile(
                title: Text(level.title),
                leading: isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : isLocked
                        ? const Icon(Icons.lock, color: Colors.grey)
                        : const Icon(Icons.play_circle_fill, color: Colors.blue),
                onTap: isLocked
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LevelScreen(level: level)),
                        ).then((_) => loadCompletedLevels()); // Refresh after return
                      },
              ),
            );
          },
        );
      },
    );
  }
}
