part of 'theme_bloc.dart';

abstract class ThemeEvent {}

/// Cargar el tema guardado (inicio de la app)
class LoadTheme extends ThemeEvent {}

/// Alternar entre light y dark
class ToggleTheme extends ThemeEvent {}

/// Establecer un tema específico
class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;

  SetTheme(this.themeMode);
}
