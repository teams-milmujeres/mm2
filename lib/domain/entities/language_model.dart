import 'dart:ui';

enum Language {
  english(Locale('en', 'US'), 'English'),
  spanish(Locale('es', 'ES'), 'Español');

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
