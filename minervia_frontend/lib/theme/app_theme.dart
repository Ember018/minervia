// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // --- Core Colors ---
  static const Color primaryPink = Color(0xFFED094A); // New main color

  // --- Light Theme Colors ---
  static const Color lightSecondaryColor = Color(0xFF4ECDC4); // Fresh Teal
  static const Color lightAccentColor = Color(0xFFFFD166); // Sunny Yellow
  static const Color lightBackgroundColor =
      Color(0xFFF7F7F7); // Light, clean background
  static const Color lightTextColor = Color(0xFF333333); // Dark grey for text
  static const Color lightCardColor = Colors.white;

  // --- Dark Theme Colors ---
  static const Color darkBackgroundColor =
      Color(0xFF121212); // Standard dark background
  static const Color darkSurfaceColor =
      Color(0xFF1E1E1E); // For cards, dialogs in dark theme
  static const Color darkTextColor =
      Color(0xFFE0E0E0); // Light grey/white for text in dark mode
  static const Color darkSecondaryColor =
      Color(0xFF03DAC6); // Teal accent for dark mode (Material standard)
  static const Color darkAccentColor =
      Color(0xFFFFAB00); // Amber/Orange accent for dark mode

  // --- Gradients (can be adjusted for dark theme if needed, or new ones created) ---
  // Using primaryPink for primary gradients
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [primaryPink, Color(0xFFFF5B8B)], // Pink to Lighter Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [primaryPink, Color(0xFFC0073A)], // Pink to Deeper Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradientLight = LinearGradient(
    colors: [lightSecondaryColor, Color(0xFF86E3CE)], // Teal to Mint
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradientDark = LinearGradient(
    colors: [
      darkSecondaryColor,
      Color(0xFF00A896)
    ], // Dark Teal to Deeper Dark Teal
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Font
  static const String _fontFamily = 'Nunito'; // A nice rounded, playful font

  // --- TextThemes (common styles, colors will be overridden by ColorScheme) ---
  static const TextTheme _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16.0),
    bodyMedium: TextStyle(fontSize: 14.0),
    labelLarge:
        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // For buttons
  );

  static const TextStyle _snackBarContentStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: _fontFamily,
    fontSize: 14,
  );

  // --- Default Theme (Dark Theme) ---
  static ThemeData get defaultTheme {
    return darkTheme;
  }

  // --- Dark Theme Data ---
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryPink,
      brightness: Brightness.dark,
      primary: primaryPink,
      secondary: darkSecondaryColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      onPrimary: Colors.white, // Text/icon on primaryPink
      onSecondary: Colors.black, // Text/icon on darkSecondaryColor
      onBackground: darkTextColor,
      onSurface: darkTextColor,
      onError: Colors.redAccent[100], // Lighter red for dark backgrounds
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryPink,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      textTheme: _baseTextTheme
          .apply(
            bodyColor: darkTextColor,
            displayColor: primaryPink, // Display text can use primary color
            decorationColor: darkTextColor,
          )
          .copyWith(
            titleLarge:
                _baseTextTheme.titleLarge?.copyWith(color: darkTextColor),
            titleMedium:
                _baseTextTheme.titleMedium?.copyWith(color: darkTextColor),
            bodyMedium:
                _baseTextTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            darkSurfaceColor, // Or primaryPink for a colored AppBar
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkTextColor, // Text color on AppBar (if solid)
        ),
        iconTheme:
            IconThemeData(color: darkTextColor), // Icons on AppBar (if solid)
        // For gradient AppBars, set flexibleSpace and ensure title/icon colors provide contrast (often white)
        // e.g., flexibleSpace: Container(decoration: BoxDecoration(gradient: AppTheme.primaryGradientDark)),
        // titleTextStyle: ... color: Colors.white ..., iconTheme: IconThemeData(color: Colors.white)
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink, // Main color for button background
          foregroundColor: Colors.white, // Text color on button
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2.0, // Subtle elevation for dark theme
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: darkSurfaceColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor
            .withOpacity(0.7), // Slightly different from card/bg
        hintStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: primaryPink, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkAccentColor,
        foregroundColor: Colors.black, // Text/icon on accent
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryPink.withOpacity(0.25),
        disabledColor: Colors.grey.withOpacity(0.5),
        selectedColor: primaryPink,
        secondarySelectedColor: darkSecondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        labelStyle:
            TextStyle(color: darkTextColor, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500), // Text on darkSecondaryColor
        brightness: Brightness.dark,
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: _snackBarContentStyle,
        //actionTextColor: darkAccentColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),

      // Add other theme properties as needed
    );
  }

  // --- Light Theme Data (kept for flexibility) ---
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryPink,
      brightness: Brightness.light,
      primary: primaryPink,
      secondary: lightSecondaryColor,
      background: lightBackgroundColor,
      surface: lightCardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: lightTextColor,
      onSurface: lightTextColor,
      error: Colors.redAccent,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryPink,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      textTheme: _baseTextTheme
          .apply(
            bodyColor: lightTextColor,
            displayColor: primaryPink,
            decorationColor: lightTextColor,
          )
          .copyWith(
            titleLarge:
                _baseTextTheme.titleLarge?.copyWith(color: lightTextColor),
            titleMedium:
                _baseTextTheme.titleMedium?.copyWith(color: lightTextColor),
            bodyMedium:
                _baseTextTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        // backgroundColor: primaryPink, // Solid color AppBar
        // For gradient AppBars use flexibleSpace (see example in main.dart or below)
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors
              .white, // Assuming gradient appbar, otherwise use lightTextColor
        ),
        iconTheme:
            IconThemeData(color: Colors.white), // Assuming gradient appbar
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink, // Use primaryPink
          foregroundColor: Colors.white, // Text color for ElevatedButton
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: lightCardColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: primaryPink, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightAccentColor,
        foregroundColor: lightTextColor,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightAccentColor.withOpacity(0.2),
        disabledColor: Colors.grey.withOpacity(0.5),
        selectedColor: primaryPink,
        secondarySelectedColor: lightSecondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        labelStyle:
            TextStyle(color: lightTextColor, fontWeight: FontWeight.w500),
        secondaryLabelStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        brightness: Brightness.light,
      ),
    );
  }
}
