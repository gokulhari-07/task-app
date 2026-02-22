part of 'tasks_composer_card.dart';

// ─── Filter Chip Row ─────────────────────────────────────────────────────────
// Sits OUTSIDE and BELOW the input card — matches the preview layout.
// onFilterChanged is the exact same ValueChanged<Filters?> from the original.

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.toLabel,
  });

  final Filters selectedFilter;
  final ValueChanged<Filters?> onFilterChanged;
  final String Function(String) toLabel;

  Color _activeBg(BuildContext c, Filters f) {
    switch (f) {
      case Filters.high:
        return _C.highBg(c);
      case Filters.medium:
        return _C.mediumBg(c);
      case Filters.low:
        return _C.lowBg(c);
      default:
        return _C.accentRedSoft;
    }
  }

  Color _activeColor(BuildContext c, Filters f) {
    switch (f) {
      case Filters.high:
        return _C.high(c);
      case Filters.medium:
        return _C.medium(c);
      case Filters.low:
        return _C.low(c);
      default:
        return _C.high(c);
    }
  }

  String _chipLabel(Filters f) {
    switch (f) {
      case Filters.high:
        return '🔴  ${toLabel(f.name)}';
      case Filters.medium:
        return '🟠  ${toLabel(f.name)}';
      case Filters.low:
        return '🟢  ${toLabel(f.name)}';
      case Filters.done:
        return '✓  ${toLabel(f.name)}';
      default:
        return toLabel(f.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "FILTER" micro-label — same visual as preview
          Text(
            'FILTER',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _C.muted(context),
              letterSpacing: 0.88,
            ),
          ),
          const SizedBox(width: 12),

          // Chips — one per Filters enum value
          ...Filters.values.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Chip(
                label: _chipLabel(filter),
                isActive: selectedFilter == filter,
                activeColor: _activeColor(context, filter),
                activeBg: _activeBg(context, filter),
                onTap: () => onFilterChanged(filter), // original callback
              ),
            );
          }),
        ],
      ),
    );
  }
}
