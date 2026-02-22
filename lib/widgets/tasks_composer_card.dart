import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow_riverpod/models/task.dart';
import 'package:taskflow_riverpod/providers/filters_provider.dart';

part 'tasks_composer_card_tokens.dart';
part 'tasks_composer_priority_dropdown.dart';
part 'tasks_composer_add_button.dart';
part 'tasks_composer_filter_chip_row.dart';
part 'tasks_composer_chip.dart';

// ─── TasksComposerCard ────────────────────────────────────────────────────────
// All constructor params IDENTICAL to original — nothing renamed or removed.
// The widget now renders TWO separate visual sections:
//   1. The input card (Container with border/radius)
//   2. The filter chip row — sitting OUTSIDE and BELOW the card
// Both are wrapped in a Column so they appear as separate elements,
// matching the preview exactly.

class TasksComposerCard extends StatelessWidget {
  const TasksComposerCard({
    super.key,
    required this.addTaskController,
    required this.selectedPriority,
    required this.selectedFilter,
    required this.onPriorityChanged,
    required this.onAddPressed,
    required this.onFilterChanged,
    required this.toLabel,
    required this.priorityColorBuilder,
  });

  final TextEditingController addTaskController;
  final Priority selectedPriority;
  final Filters selectedFilter;
  final ValueChanged<Priority?> onPriorityChanged; // untouched
  final VoidCallback onAddPressed; // untouched
  final ValueChanged<Filters?> onFilterChanged; // untouched
  final String Function(String) toLabel; // untouched
  final Color Function(Priority) priorityColorBuilder; // untouched

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section 1: Input card (bordered container) ──────────────────────
        Container(
          decoration: BoxDecoration(
            color: _C.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _C.border(context)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Task text field — controller is original prop, untouched
              Expanded(
                child: TextField(
                  controller: addTaskController,
                  style: GoogleFonts.dmSans(
                    fontSize: 15, // ← increased from 15
                    color: _C.text(context),
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    hintText: 'Add a new task...',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: _C.muted(context),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    // Vertical padding expands the field's tap/click area
                    // and visually centres the larger text — outer container
                    // height stays the same because Row sizes to its tallest
                    // child (the dropdown/add button), not the TextField.
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  cursorColor: _C.accentRed,
                  onSubmitted: (_) => onAddPressed(), // original callback
                ),
              ),
              const SizedBox(width: 10),

              // Priority dropdown
              _PriorityDropdown(
                selectedPriority: selectedPriority,
                onPriorityChanged: onPriorityChanged, // original callback
                toLabel: toLabel, // original fn
              ),
              const SizedBox(width: 10),

              // Add button
              _AddButton(onPressed: onAddPressed), // original callback
            ],
          ),
        ),

        // ── Section 2: Filter chip row — OUTSIDE the card ───────────────────
        // Gap between card and chips — matches preview spacing
        const SizedBox(height: 12),

        _FilterChipRow(
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged, // original callback, untouched
          toLabel: toLabel, // original fn, untouched
        ),
      ],
    );
  }
}
