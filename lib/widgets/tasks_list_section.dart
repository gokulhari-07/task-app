import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow_riverpod/app_colors.dart';
import 'package:taskflow_riverpod/models/task.dart';

part 'tasks_list_section_empty_state.dart';
part 'tasks_list_section_task_item_card.dart';

class TasksListSection extends StatelessWidget {
  const TasksListSection({
    super.key,
    required this.tasks,
    required this.toLabel,
    required this.priorityColorBuilder,
    required this.onToggleTask,
    required this.onDeleteTask,
    this.shrinkWrap = false,
    this.scrollPhysics,
    this.useColumnLayout = false,
  });

  final List<Task> tasks;
  final String Function(String) toLabel;
  final Color Function(Priority) priorityColorBuilder;
  final ValueChanged<String> onToggleTask;
  final ValueChanged<String> onDeleteTask;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  final bool useColumnLayout;

  @override
  Widget build(BuildContext context) {
    final Widget listContent;

    if (tasks.isEmpty) {
      listContent = const _TasksEmptyState();
    } else if (useColumnLayout) {
      listContent = Column(
        key: const ValueKey('task-list-column'),
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < tasks.length; index++) ...[
            _TaskItemCard(
              task: tasks[index],
              toLabel: toLabel,
              priorityColorBuilder: priorityColorBuilder,
              onToggleTask: onToggleTask,
              onDeleteTask: onDeleteTask,
            ),
            if (index != tasks.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    } else {
      listContent = ListView.separated(
        key: const ValueKey('task-list'),
        itemCount: tasks.length,
        shrinkWrap: shrinkWrap,
        physics: scrollPhysics,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _TaskItemCard(
            task: task,
            toLabel: toLabel,
            priorityColorBuilder: priorityColorBuilder,
            onToggleTask: onToggleTask,
            onDeleteTask: onDeleteTask,
          );
        },
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: listContent,
    );
  }
}
