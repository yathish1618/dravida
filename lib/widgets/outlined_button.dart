import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon; // ✅ Added icon parameter

  const OutlinedButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon, // ✅ Accept optional icons
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon( // ✅ Use OutlinedButton.icon for icon support
      onPressed: onPressed,
      icon: icon ?? const SizedBox(), // ✅ Ensures icon parameter works
      label: Text(label),
    );
  }
}