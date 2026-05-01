import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  //final Color color, textColor;
  final bool isDisabled;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    // this.color = Colors.teal,
    //this.textColor = Colors.white,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // minimumSize: const Size.fromWidth(50), // NEW
        minimumSize: const Size(
          150,
          48,
        ), // takes postional arguments as width and height
      ),
      onPressed: !isDisabled ? press : null,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
