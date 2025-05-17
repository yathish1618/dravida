import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/module_model.dart';
import '../widgets/ui_components.dart';
import '../widgets/app_header.dart';
import '../screens/module_screen.dart';
import '../theme/app_theme.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App header
              const AppHeader(),
              
              const SizedBox(height: 16),
              
              // Hero section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.9),
                        AppTheme.secondaryColor.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Your Kannada Journey',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Learn at your own pace with interactive lessons',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Get Started',
                              onPressed: () {
                                // Add functionality here
                              },
                              icon: Icons.play_arrow,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'ಕ',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Learning modules title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Learning Modules',
                  style: AppTheme.subheadingStyle,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Modules list
              Expanded(
                child: FutureBuilder<List<Module>>(
                  future: ApiService.getModules(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Add refresh functionality if needed
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final modules = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: modules.length,
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        
                        // Assign an icon based on module name
                        IconData moduleIcon = Icons.book;
                        String? subtitle;
                        
                        if (module.name.toLowerCase().contains('alphabet')) {
                          moduleIcon = Icons.sort_by_alpha;
                          subtitle = 'Learn Kannada script';
                        } else if (module.name.toLowerCase().contains('vocabulary')) {
                          moduleIcon = Icons.menu_book;
                          subtitle = 'Basic words and phrases';
                        } else if (module.name.toLowerCase().contains('grammar')) {
                          moduleIcon = Icons.format_list_numbered;
                          subtitle = 'Language structure and rules';
                        } else if (module.name.toLowerCase().contains('conversation')) {
                          moduleIcon = Icons.chat_bubble_outline;
                          subtitle = 'Practice daily conversations';
                        }
                        
                        return ModuleCard(
                          title: module.name,
                          subtitle: subtitle,
                          icon: moduleIcon,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ModuleScreen(module: module),
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