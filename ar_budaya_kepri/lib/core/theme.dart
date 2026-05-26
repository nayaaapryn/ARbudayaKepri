import 'package:flutter/material.dart';

/// Premium design tokens and color scheme inspired by the Riau Islands.
/// Employs a rich maritime deep teal, soft sands, and tropical emerald accents.
class AppTheme {
  // Brand color palette
  static const Color oceanTealDark = Color(0xFF0D3B43);
  static const Color oceanTealPrimary = Color(0xFF145D6A);
  static const Color oceanTealLight = Color(0xFF3B8F9E);
  static const Color emeraldAccent = Color(0xFF10B981);
  static const Color sandGold = Color(0xFFD4AF37);
  
  // Backgrounds and card tones
  static const Color backgroundLight = Color(0xFFF4F9F4);
  static const Color cardBgLight = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  /// Dark mode palette for high contrast/premium visual feel
  static const Color backgroundDark = Color(0xFF0A0F11);
  static const Color cardBgDark = Color(0xFF151E22);
  static const Color textDarkPrimary = Color(0xFFE2E8F0);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oceanTealPrimary,
        primary: oceanTealPrimary,
        secondary: emeraldAccent,
        tertiary: sandGold,
        surface: cardBgLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textDark,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textLight,
          height: 1.4,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      cardTheme: CardThemeData(
        color: cardBgLight,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oceanTealPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: oceanTealLight,
        secondary: emeraldAccent,
        tertiary: sandGold,
        surface: cardBgDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDarkPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDarkPrimary,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDarkPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textDarkPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textDarkSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDarkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDarkPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardBgDark,
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oceanTealLight,
          foregroundColor: backgroundDark,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Glassmorphism card decoration helper
BoxDecoration glassmorphicDecoration({required Brightness brightness}) {
  return BoxDecoration(
    color: brightness == Brightness.dark 
        ? Colors.white.withValues(alpha: 0.05) 
        : Colors.white.withValues(alpha: 0.7),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
