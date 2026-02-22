import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// 🧠 themeModeProvider lives here instead of _MyAppState because:
// - Widget state (_MyAppState) is local to one widget subtree.
// - Any widget that needs to read or toggle the theme would need
//   the callback/value drilled down as props (isDarkMode, onThemeToggle).
// - A StateProvider is globally accessible — any widget can read or
//   toggle the theme with just ref.watch / ref.read, no prop drilling.

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
// StateProvider is used here (not StateNotifierProvider) because
// ThemeMode is a simple value with no complex mutation logic.
// Toggling is just: notifier.state = newValue