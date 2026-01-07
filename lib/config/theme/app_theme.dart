import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;

    final colorPrimary = Colors.teal;

    final colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.teal, // Color principal (botones, etc.)
      onPrimary: Colors.white, // Texto sobre el color primario
      secondary: Colors.tealAccent, // Color secundario (chips, switches)
      onSecondary: Colors.black, // Texto sobre el secundario
      error: Colors.red, // Errores
      onError: Colors.white, // Texto sobre errores
      surface: Colors.white, // Cards, Sheets, etc.
      onSurface: Colors.black87, // Texto sobre surface
    );

    final customTextTheme = GoogleFonts.poppinsTextTheme(
      baseTextTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.poppins(
        // Título grande
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: colorPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        // Título secundario
        fontSize: 20,
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
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: customTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
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
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: customTextTheme.bodyMedium,
        hintStyle: customTextTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
        scrimColor: Colors.black54,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorPrimary,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colorPrimary,
        labelStyle: customTextTheme.titleMedium,
        unselectedLabelStyle: customTextTheme.bodyMedium,
      ),
      // ✅ Tema para NavigationBar de Material 3
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: colorScheme.primary.withAlpha(
          25,
        ), // Reemplazo de .withOpacity(0.1)

        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customTextTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
            );
          }
          return customTextTheme.bodyMedium?.copyWith(color: Colors.black54);
        }),

        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return const IconThemeData(color: Colors.black54);
        }),
      ),
    );
  }

  ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;

    final colorPrimary = Colors.teal;

    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.teal,
      onPrimary: Colors.black,
      secondary: Colors.teal,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.black,
      surface: Color(0xFF121212),
      onSurface: Colors.white70,
    );

    final customTextTheme = GoogleFonts.poppinsTextTheme(
      baseTextTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: colorPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: colorPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );

    return ThemeData(
      scaffoldBackgroundColor: Color(0xFF121212),
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: customTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          textStyle: customTextTheme.labelLarge,
          backgroundColor: colorPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(0, 0),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: customTextTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colorPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: customTextTheme.bodyMedium,
        hintStyle: customTextTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorPrimary),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Color(0xFF121212),
        scrimColor: Colors.black54,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorPrimary,
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colorPrimary,
        labelStyle: customTextTheme.titleMedium,
        unselectedLabelStyle: customTextTheme.bodyMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Color(0xFF121212),
        indicatorColor: colorScheme.primary.withAlpha(25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return customTextTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
            );
          }
          return customTextTheme.bodyMedium?.copyWith(color: Colors.white54);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return const IconThemeData(color: Colors.white54);
        }),
      ),
    );
  }
}
