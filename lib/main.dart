import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/module_screen.dart'; // Import ModuleScreen
import 'screens/level_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/item_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DravidaApp());
}

class DravidaApp extends StatelessWidget {
  const DravidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null ? "/" : "/modules",
      onGenerateRoute: (settings) {
        if (settings.name == "/levels") {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey("moduleId")) {
            return MaterialPageRoute(builder: (context) => const ModuleScreen()); // Fallback if missing moduleId
          }
          return MaterialPageRoute(builder: (context) => LevelScreen(moduleId: args["moduleId"]));
        }
        if (settings.name == "/items") {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey("levelId") || !args.containsKey("moduleId")) {
            return MaterialPageRoute(builder: (context) => const ModuleScreen());
          }
          return MaterialPageRoute(builder: (context) => ItemScreen(levelId: args["levelId"], moduleId: args["moduleId"]));
        }
        return null;
      },
      routes: {
        "/": (context) => const WelcomeScreen(),
        "/signup": (context) => const SignupScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/modules": (context) => const ModuleScreen(),
        "/settings": (context) => const SettingsScreen(), // Add Settings Route
      },
    );
  }
}