import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        onSurfaceVariant: Colors.teal,
      ),
    );
  }
}
