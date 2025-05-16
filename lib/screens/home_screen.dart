import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/module_model.dart';
import '../widgets/module_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn Kannada')),
      body: FutureBuilder<List<Module>>(
        future: ApiService.getModules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ModuleList(modules: snapshot.data!);
        },
      ),
    );
  }
}