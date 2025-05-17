import 'package:flutter/material.dart';
import '../models/module_model.dart';
import '../widgets/app_header.dart';
import '../widgets/ui_components.dart';
import '../services/api_service.dart';
import '../models/level_model.dart';
import '../screens/level_screen.dart';
import '../theme/app_theme.dart';

class ModuleScreen extends StatelessWidget {
  final Module module;
  
  const ModuleScreen({super.key, required this.module});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App header with back button
              AppHeader(
                showBackButton: true,
                title: module.name,
              ),
              
              const SizedBox(height: 16),
              
              // Module info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Module Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This module contains ${module.levelIds.length} levels. Complete all levels to master this module.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Levels heading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Levels',
                  style: AppTheme.subheadingStyle,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Levels list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: module.levelIds.length,
                  itemBuilder: (context, index) {
                    final levelId = module.levelIds[index];
                    
                    return FutureBuilder<Level>(
                      future: ApiService.getLevel(levelId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            child: Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Error loading level: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        
                        final level = snapshot.data!;
                        
                        // Mark some levels as completed for UI demonstration
                        bool isCompleted = index == 0; // First level completed for demo
                        
                        return LevelCard(
                          title: level.title,
                          isCompleted: isCompleted,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LevelScreen(level: level),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}