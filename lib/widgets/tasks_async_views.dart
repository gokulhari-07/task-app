import 'package:flutter/material.dart';

class TasksLoadingView extends StatelessWidget {
  const TasksLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Preparing your workspace...",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class TasksErrorView extends StatelessWidget {
  const TasksErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: colors.errorContainer.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "Error: $error",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
