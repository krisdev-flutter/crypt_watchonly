import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF070B0A);
  static const Color surface = Color(0xFF101715);
  static const Color surfaceRaised = Color(0xFF151E1A);
  static const Color border = Color(0xFF24312B);
  static const Color emerald = Color(0xFF39E58C);
  static const Color muted = Color(0xFF91A198);
  static const Color danger = Color(0xFFFF667A);

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: emerald,
      onPrimary: Color(0xFF042014),
      secondary: Color(0xFF8AF0B7),
      onSecondary: Color(0xFF052315),
      error: danger,
      onError: Color(0xFF2B0710),
      surface: surface,
      onSurface: Color(0xFFF2F7F3),
      outline: border,
      shadow: Colors.black,
      inverseSurface: Color(0xFFE7F1EA),
      onInverseSurface: Color(0xFF17201A),
      inversePrimary: Color(0xFF087A43),
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      splashColor: emerald.withOpacity(0.08),
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Color(0xFFF2F7F3),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFFF2F7F3),
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border, width: 0.8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: muted, fontSize: 14),
        prefixIconColor: muted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: emerald, width: 1.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceRaised,
        selectedColor: emerald.withOpacity(0.16),
        disabledColor: surface,
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: emerald),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0C110F),
        indicatorColor: emerald.withOpacity(0.14),
        elevation: 0,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected) ? emerald : muted,
            )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? emerald : muted,
            )),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: emerald,
        linearTrackColor: border,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: emerald,
          foregroundColor: const Color(0xFF052014),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1.1),
        headlineMedium: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -0.6),
        titleLarge: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 14, height: 1.45),
        bodyMedium: TextStyle(fontSize: 13, height: 1.4),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Kept as a compatibility alias for any existing call sites.
  static ThemeData get light => dark;
}
