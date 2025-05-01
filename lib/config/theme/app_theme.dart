import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;

    final colorPrimary = Colors.teal;

    final customTextTheme = GoogleFonts.poppinsTextTheme(
      baseTextTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.poppins(
        // Título grande
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: colorPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        // Subtítulo o título secundario
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodyLarge: GoogleFonts.poppins(
        // Párrafo principal
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.poppins(
        // Texto secundario
        fontSize: 14,
        color: Colors.black54,
      ),
      labelLarge: GoogleFonts.poppins(
        // Botones
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    );

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorPrimary,
        onSurfaceVariant: colorPrimary,
      ),
      textTheme: customTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: customTextTheme.labelLarge,
          backgroundColor: colorPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(0, 0), // No fixed minimum size
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ), // Adjust padding as needed
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: customTextTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colorPrimary),
      ),
    );
  }
}
