import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow_riverpod/providers/theme_provider.dart';
import 'package:taskflow_riverpod/screens/tasks_screen.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true; 
// Current project status:
// - Uses runtime font fetching.
// - Evidence:
//   - lib/main.dart: GoogleFonts.config.allowRuntimeFetching = true;
//   - pubspec.yaml: no active flutter.fonts section (only comments)
//   - No local .ttf/.otf files in repo

// Meaning:
// - allowRuntimeFetching = true -> google_fonts can download fonts from the internet at runtime and cache them.
// - allowRuntimeFetching = false -> no runtime download; app uses only bundled/local fonts.

// How to bundle locally:
// 1) Put font files in assets/fonts/ (example: DMSans-Regular.ttf)
// 2) Add flutter.fonts entries in pubspec.yaml
// 3) Set allowRuntimeFetching = false
// 4) Use TextStyle(fontFamily: 'YourFamilyName')

// Which is better:
// - Production: Local bundled fonts (more reliable/offline-safe, predictable).
// - Prototyping: Runtime fetching (faster setup, less initial asset work).

  runApp(
    const ProviderScope(child: MyApp()),
  ); //ProviderScope = dependency injection root for Riverpod. If this is missing, nothing will work later.
}

// 🧠 MyApp is now a ConsumerWidget instead of StatefulWidget.
// Before: theme state lived in _MyAppState (widget state) using setState().
// After: theme state lives in themeModeProvider, so MyApp just reads it.
// MyApp no longer needs to be stateful — it has no local state left to manage.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
  }) {
    final baseTextTheme =
        (colorScheme.brightness == Brightness.dark
                ? ThemeData.dark()
                : ThemeData.light())
            .textTheme;
    final appTextTheme = GoogleFonts.manjariTextTheme(baseTextTheme);
    final inputFillColor = colorScheme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.38)
        : const Color(0xFFFFF8FA).withValues(alpha: 0.9);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textTheme: appTextTheme.copyWith(
        titleMedium: appTextTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: appTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: appTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  @override
  // 🧠 build now receives (context, ref) because MyApp is a ConsumerWidget.
  // ref.watch(themeModeProvider) replaces the old _themeMode local state field.
  // When the provider value changes, ConsumerWidget rebuilds automatically —
  // same as setState() did before, but now triggered by the provider.
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // 🧠 No more _toggleThemeMode method defined here.
    // Toggling is now done inside TasksScreen directly via ref.read(themeModeProvider.notifier).
    // MyApp doesn't need to know about toggling at all.

    const lightColorScheme = ColorScheme.light(
      surface: Color(0xFFFFF8FA),
      onSurface: Color(0xFF1A1918),
      primary: Color(0xFFC0392B),
    );
    const darkColorScheme = ColorScheme.dark(
      surface: Color(0xFF1C1B1A),
      onSurface: Color(0xFFF0EDE8),
      primary: Color(0xFFC0392B),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: const Color(0xFFFDF4F7),
      ),
      darkTheme: _buildTheme(
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: const Color(0xFF111010),
      ),
      themeMode: themeMode,
      // 🧠 No more isDarkMode or onThemeToggle props passed to TasksScreen.
      // TasksScreen will read themeModeProvider and toggle it directly.
      // This eliminates prop drilling entirely.
      home: const TasksScreen(),
    );
  }
}