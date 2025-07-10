import 'package:flutter/material.dart';

class RoundedButtonLarge extends StatelessWidget {
  final String text;
  final VoidCallback press;
  // final Color color, textColor;
  final bool isDisabled;
  final IconData? icon;
  const RoundedButtonLarge({
    super.key,
    required this.text,
    required this.press,
    required this.icon,
    // this.color = Colors.teal,
    // this.textColor = Colors.white,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
      child: ElevatedButton.icon(
        icon:
            icon != null
                ? Icon(icon, color: Theme.of(context).colorScheme.onPrimary)
                : const SizedBox.shrink(), // If no icon, show nothing
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          // minimumSize: const Size.fromWidth(50), // NEW
          minimumSize: const Size(
            150,
            48,
          ), // takes postional arguments as width and height
        ),
        onPressed: !isDisabled ? press : null,
        label: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
