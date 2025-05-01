import 'package:flutter/material.dart';

enum Language {
  english(Locale('en', 'US'), 'English', Colors.blue),
  spanish(Locale('es', 'ES'), 'Español', Colors.red);

  const Language(this.value, this.text, this.color);

  final Locale value;
  final String text;
  final Color color;
}
