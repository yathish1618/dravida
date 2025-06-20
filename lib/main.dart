import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/initial_screen.dart';  // A simple auth gatekeeper widget.
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/module_screen.dart';
import 'screens/level_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/item_screen.dart';

import 'config.dart';

void main() async {
  // Initialize Flutter binding & Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabaseAnon,
  );
  runApp(const DravidaApp());
}

class DravidaApp extends StatelessWidget {
  const DravidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dravida',
      debugShowCheckedModeBanner: false,
      // Always start at the root route "/"
      initialRoute: "/",
      // Remove the static routes map and use onGenerateRoute for centralized routing.
      onGenerateRoute: (RouteSettings settings) {
        // Define a list of routes that do NOT require authentication.
        const unprotectedRoutes = ["/", "/home", "/login", "/signup"];
        // If the requested route is not in the unprotected list, then it’s considered protected.
        final requiresAuth = !unprotectedRoutes.contains(settings.name);

        // If the route is protected and there's no authenticated user, redirect to HomeScreen.
        if (requiresAuth && FirebaseAuth.instance.currentUser == null) {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }

        // Handle routing for supported paths.
        switch (settings.name) {
          case "/":
            // The root route now uses InitialScreen which returns HomeScreen or WelcomeScreen
            // based on the current user state.
            return MaterialPageRoute(builder: (context) => const InitialScreen());
          case "/home":
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case "/welcome":
            return MaterialPageRoute(builder: (context) => const WelcomeScreen());
          case "/signup":
            return MaterialPageRoute(builder: (context) => const SignupScreen());
          case "/login":
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case "/modules":
            return MaterialPageRoute(builder: (context) => const ModuleScreen());
          case "/settings":
            return MaterialPageRoute(builder: (context) => const SettingsScreen());
          case "/levels":
            // Extract arguments for levels.
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null || !args.containsKey("moduleId")) {
              // Fallback if required arguments are missing.
              return MaterialPageRoute(builder: (context) => const ModuleScreen());
            }
            return MaterialPageRoute(
                builder: (context) => LevelScreen(moduleId: args["moduleId"]));
          case "/items":
          // Extract arguments for items.
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null ||
              !args.containsKey("levelId") ||
              !args.containsKey("moduleId") ||
              !args.containsKey("levelTitle")) {
            return MaterialPageRoute(builder: (context) => const ModuleScreen());
          }
          return MaterialPageRoute(
            builder: (context) => ItemScreen(
              levelId: args["levelId"],
              moduleId: args["moduleId"],
              levelTitle: args["levelTitle"],
            ),
          );

          default:
            // For unknown routes, redirect to HomeScreen.
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
    );
  }
}
