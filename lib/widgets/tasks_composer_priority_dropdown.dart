part of 'tasks_composer_card.dart';

// ─── Priority Dropdown ───────────────────────────────────────────────────────
class _PriorityDropdown extends StatefulWidget {
  const _PriorityDropdown({
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.toLabel,
  });

  final Priority selectedPriority;
  final ValueChanged<Priority?> onPriorityChanged;
  final String Function(String) toLabel;

  @override
  State<_PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<_PriorityDropdown> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _C.surface2(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused ? _C.muted(context) : _C.border(context),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated colored dot — reflects selected priority
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _C.priorityDot(context, widget.selectedPriority),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),

          Focus(
            onFocusChange: (f) => setState(() => _focused = f),
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                child: DropdownButton<Priority>(
                  value: widget.selectedPriority,
                  isDense: true,
                  dropdownColor: _C.surface2(context),
                  borderRadius: BorderRadius.circular(14),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _C.text(context),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _C.muted(context),
                    size: 16,
                  ),
                  // Original items mapping — untouched
                  items: Priority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(widget.toLabel(priority.name)),
                    );
                  }).toList(),
                  onChanged: widget.onPriorityChanged, // original callback
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
