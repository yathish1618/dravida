import 'package:flutter/material.dart';
import '../models/module_model.dart';
import '../widgets/level_list.dart';

class ModuleScreen extends StatelessWidget {
  final Module module;

  const ModuleScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.name)),
      body: LevelList(levelIds: module.levelIds),
    );
  }
}