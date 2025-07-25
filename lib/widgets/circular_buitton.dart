import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final IconData? icon;
  final bool isDisabled;
  final bool invertedColors; // <-- NUEVO

  const CircularButton({
    super.key,
    required this.text,
    this.icon,
    required this.press,
    this.isDisabled = false,
    this.invertedColors = false, // <-- NUEVO
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        invertedColors
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.primary;
    final foregroundColor =
        invertedColors
            ? theme.colorScheme.primary
            : theme.colorScheme.onPrimary;

    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      minimumSize: const Size(200, 50),
    );

    return icon != null
        ? ElevatedButton.icon(
          style: style,
          icon: Icon(icon, color: foregroundColor),
          label: Text(text),
          onPressed: !isDisabled ? press : null,
        )
        : ElevatedButton(
          style: style,
          onPressed: !isDisabled ? press : null,
          child: Text(text),
        );
  }
}
