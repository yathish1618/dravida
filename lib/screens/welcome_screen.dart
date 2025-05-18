import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.7;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome_banner.png"),
            repeat: ImageRepeat.repeat, // ✅ Tessellates image both horizontally & vertically
            scale: 2.0, // ✅ Shrinks the base image before tiling
            filterQuality: FilterQuality.high,
            fit: BoxFit.none, // ✅ Prevents scaling by default
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.dstATop), // ✅ Reduces opacity
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ PNG Logo
              SizedBox(
                width: 300,
                height: 300,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              // ✅ Sign Up Button with shadow effect
              Container(
                width: buttonWidth,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  label: "Sign Up",
                  onPressed: () => Navigator.pushNamed(context, "/signup"),
                ),
              ),
              const SizedBox(height: 10),
              // ✅ Log In Button with shadow effect
              Container(
                width: buttonWidth,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: PrimaryButtonWhite(
                  label: "Log In",
                  onPressed: () => Navigator.pushNamed(context, "/login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}