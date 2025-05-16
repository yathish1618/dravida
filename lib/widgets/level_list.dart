import '../services/api_service.dart';  // Add this
import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../screens/level_screen.dart';


class LevelList extends StatelessWidget {
  final List<String> levelIds;

  const LevelList({super.key, required this.levelIds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: levelIds.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Level>(
          future: ApiService.getLevel(levelIds[index]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final level = snapshot.data!;
              return ListTile(
                title: Text(level.title),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LevelScreen(level: level),
                  ),
                ),
              );
            }
            return const ListTile(title: Text('Loading...'));
          },
        );
      },
    );
  }
}