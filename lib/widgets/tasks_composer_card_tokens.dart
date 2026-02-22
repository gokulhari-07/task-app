part of 'tasks_composer_card.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
class _C {
  static bool _d(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color surface(BuildContext c) =>
      _d(c) ? const Color(0xFF1C1B1A) : const Color(0xFFFFF8FA);
  static Color surface2(BuildContext c) =>
      _d(c) ? const Color(0xFF242322) : const Color(0xFFF0EDE8);
  static Color border(BuildContext c) =>
      _d(c) ? const Color(0xFF2E2D2B) : const Color(0xFFE2DDD8);
  static Color text(BuildContext c) =>
      _d(c) ? const Color(0xFFF0EDE8) : const Color(0xFF1A1918);
  static Color muted(BuildContext c) =>
      _d(c) ? const Color(0xFF6B6762) : const Color(0xFF9B9590);

  static Color high(BuildContext c) =>
      _d(c) ? const Color(0xFFE05252) : const Color(0xFFC0392B);
  static Color done(BuildContext c) => _d(c)
      ? const Color.fromARGB(255, 88, 177, 228)
      : const Color.fromARGB(255, 55, 143, 197);
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

  static Color priorityDot(BuildContext c, Priority p) {
    switch (p) {                            
      case Priority.high:
        return high(c);
      case Priority.medium:
        return medium(c);
      case Priority.low:
        return low(c);
    }
  }
}
