import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow_riverpod/app_colors.dart';
import 'package:taskflow_riverpod/providers/theme_provider.dart';

class TaskScreenAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const TaskScreenAppBar({
    super.key,
    //required this.isDarkMode,
    //required this.onThemeToggle, 
  });

  //final bool isDarkMode;
  //final VoidCallback onThemeToggle;

  @override
  Size get preferredSize => const Size.fromHeight(132);

  @override
  ConsumerState<TaskScreenAppBar> createState() {
    return _TaskScreenAppBarState();
  }
}

class _TaskScreenAppBarState extends ConsumerState<TaskScreenAppBar> {
  bool _isHovered = false;

  void _toggleTheme() {
    ref
        .read(themeModeProvider.notifier)
        .state = ref.read(themeModeProvider.notifier).state == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  /*
  StateProvider — Read vs Write in Riverpod

The Rule:
  Read  → ref.read(myProvider)                  returns the raw value
  Write → ref.read(myProvider.notifier).state =  sets a new value

Why you can't use ref.read(myProvider) on the left side:
  ref.read(myProvider) returns the value itself (e.g. ThemeMode.dark), not a settable property.
  Assigning to it is like doing ThemeMode.dark = something which makes no sense.
  .notifier gives you the StateController — the box that holds the value
  and exposes a settable .state property.

  ref.read(myProvider)                →  the value inside the box      (read only)
  ref.read(myProvider.notifier)       →  the box itself
  ref.read(myProvider.notifier).state →  the lid you open to swap value (read + write)

In practice — toggle pattern:

  // ✅ Clean & idiomatic
  ref.read(themeModeProvider.notifier).state =
      ref.read(themeModeProvider) == ThemeMode.dark   // read → direct
          ? ThemeMode.light
          : ThemeMode.dark;

  // ✅ Works but verbose
  ref.read(themeModeProvider.notifier).state =
      ref.read(themeModeProvider.notifier).state == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;

  // ❌ Invalid — can't assign to a raw value
  ref.read(themeModeProvider) = ThemeMode.light;

To trigger UI rebuild — use watch in build, read in callbacks:

  // in build() → rebuilds widget when value changes
  ref.watch(themeModeProvider);

  // in onTap / functions → just reads/writes, no rebuild subscription
  ref.read(themeModeProvider.notifier).state = ...
   */
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 132,
      backgroundColor: AppColors.bg(context),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task",
                  style: GoogleFonts.syne(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text(context),
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Turn plans into progress",
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: AppColors.muted(context),
                  ),
                ),
              ],
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false;
                });
              },
              child: GestureDetector(
                onTap: _toggleTheme, 
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 8, 15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.muted(context)
                          : AppColors.border(context),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Theme.of(context).brightness == Brightness.dark
                      ? Icon(
                          Icons.light_mode,
                          color: const Color(0xFFFFB300),
                          size: 20,
                        )
                      : Icon(
                          Icons.dark_mode,
                          color: const Color(0xFF90CAF9),
                          size: 20,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
