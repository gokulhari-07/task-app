import 'package:flutter/material.dart';

class AppColors {
  static bool _d(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color bg(BuildContext c) =>
      _d(c) ? const Color(0xFF111010) : const Color(0xFFFDF4F7);
  static Color surface(BuildContext c) =>
      _d(c) ? const Color(0xFF1C1B1A) : const Color(0xFFFFF8FA);
  static Color surface2(BuildContext c) =>
      _d(c) ? const Color(0xFF242322) : const Color(0xFFF0EDE8);
  static Color border(BuildContext c) =>
      _d(c) ? const Color(0xFF2E2D2B) : const Color(0xFFE2DDD8);
  static Color borderHover(BuildContext c) =>
      _d(c) ? const Color(0xFF3A3937) : const Color(0xFFC8C3BC);
  static Color text(BuildContext c) =>
      _d(c) ? const Color(0xFFF0EDE8) : const Color(0xFF1A1918);
  static Color muted(BuildContext c) =>
      _d(c) ? const Color(0xFF6B6762) : const Color(0xFF9B9590);
  static Color taskHover(BuildContext c) =>
      _d(c) ? const Color(0xFF1F1E1D) : const Color(0xFFFFF2F6);
  static Color glow(BuildContext c) =>
      _d(c) ? const Color(0x0FC0392B) : const Color(0x08C0392B);
  static Color high(BuildContext c) =>
      _d(c) ? const Color(0xFFE05252) : const Color(0xFFC0392B);
  static Color highBg(BuildContext c) =>
      _d(c) ? const Color(0x1FE05252) : const Color(0x17C0392B);
  static Color medium(BuildContext c) =>
      _d(c) ? const Color(0xFFD4955A) : const Color(0xFFB8731A);
  static Color mediumBg(BuildContext c) =>
      _d(c) ? const Color(0x1FD4955A) : const Color(0x17B8731A);
  static Color low(BuildContext c) =>
      _d(c) ? const Color(0xFF5AAD7A) : const Color(0xFF2E8B57);
  static Color lowBg(BuildContext c) =>
      _d(c) ? const Color(0x1F5AAD7A) : const Color(0x172E8B57);

  static const accentRed = Color(0xFFC0392B);
  static const accentRedSoft = Color(0x26C0392B);
}
