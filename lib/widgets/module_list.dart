import 'package:flutter/material.dart';
import '../models/module_model.dart';
import '../screens/module_screen.dart';

class ModuleList extends StatelessWidget {
  final List<Module> modules;

  const ModuleList({super.key, required this.modules});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return ListTile(
          title: Text(module.name),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModuleScreen(module: module),
            ),
          ),
        );
      },
    );
  }
}