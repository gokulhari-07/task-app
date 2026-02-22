part of 'tasks_list_section.dart';

class _TasksEmptyState extends StatelessWidget {
  const _TasksEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty-state'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.4,
              child: Text(
                '\u2713',
                style: GoogleFonts.dmSans(
                  fontSize: 36,
                  color: AppColors.muted(context),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks here',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.muted(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
