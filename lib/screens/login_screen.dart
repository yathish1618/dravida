import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/custom_textfields.dart';
import '../widgets/custom_buttons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart'; // ✅ Google Sign-In Button

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _login() async {
    if (_formKey.currentState!.validate()) { // ✅ Validate form before login
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final user = await _authService.loginWithEmail(email, password);
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(context, "/welcome", (route) => false); // Navigate to Home
      }
    }
  }

  void _signUpWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(context, "/welcome", (route) => false); // Navigate after Google sign-in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // ✅ Wrap input fields in Form widget for validation
          child: Column(
            children: [
              const Text("Welcome Back!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // ✅ Spaced input fields
              LoginTextField(
                controller: _emailController, 
                label: "Email",
                keyboardType: TextInputType.emailAddress, 
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Email cannot be empty";
                  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                  return emailRegex.hasMatch(value) ? null : "Enter a valid email";
                },
              ),
              const SizedBox(height: 16), // ✅ Added spacing

              LoginTextField(
                controller: _passwordController, 
                label: "Password", 
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Styled Log In Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ // ✅ Added drop shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: LoginButton(label: "Log In", onPressed: _login),
              ),

              const SizedBox(height: 10),
              const Text("OR", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),

              // ✅ Styled Google Sign-In Button (Matching Size)
              Container(
                width: double.infinity,
                height: 50, // ✅ Matches "Log In" button height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [ // ✅ Added drop shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: _signUpWithGoogle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}