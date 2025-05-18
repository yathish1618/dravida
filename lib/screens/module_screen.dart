import 'package:flutter/material.dart';
import '../services/strapi_service.dart';
import '../widgets/bottom_nav_bar.dart';


class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final StrapiService _strapiService = StrapiService();
  List<Map<String, dynamic>> _modules = [];

  @override
  void initState() {
    super.initState();
    _fetchModules();
  }

  void _fetchModules() async {
    final modules = await _strapiService.fetchModules();

    // Sort modules in ascending order based on the 'order' field
    modules.sort((a, b) => (a["order"] ?? 0).compareTo(b["order"] ?? 0));
    setState(() {
      _modules = modules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modules")),
      body: _modules.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _modules.length,
              itemBuilder: (context, index) {
                final module = _modules[index];
                return _buildModuleCard(module);
              },
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Modules tab
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    double progress = (module["progress"] ?? 0) / 100; // Normalize percentage

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
            strokeWidth: 6,
          ),
        ),
        title: Text(module["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(module["description"]),
        trailing: Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onTap: () => Navigator.pushNamed(
          context, 
          "/levels", 
          arguments: {"moduleId": module["id"].toString()}, // Pass module ID correctly
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamed(context, "/home"); // Redirect to Home
    } else if (index == 1) {
      Navigator.pushNamed(context, "/modules"); // Redirect to Modules
    } else if (index == 2) {
      Navigator.pushNamed(context, "/settings"); // Redirect to Settings
    }
  }
}