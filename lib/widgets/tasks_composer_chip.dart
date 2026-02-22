part of 'tasks_composer_card.dart';

// ─── Individual Chip ─────────────────────────────────────────────────────────
class _Chip extends StatefulWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.activeBg,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final Color activeBg;
  final VoidCallback onTap;

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isActive ? widget.activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isActive
                  ? widget.activeColor
                  : _hovered
                  ? _C.muted(context)
                  : _C.border(context),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: widget.isActive
                  ? widget.activeColor
                  : _hovered
                  ? _C.text(context)
                  : _C.muted(context),
            ),
          ),
        ),
      ),
    );
  }
}
