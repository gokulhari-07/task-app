part of 'tasks_list_section.dart';

class _TaskItemCard extends StatefulWidget {
  const _TaskItemCard({
    required this.task,
    required this.toLabel,
    required this.priorityColorBuilder,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  final Task task;
  final String Function(String) toLabel;
  final Color Function(Priority) priorityColorBuilder;
  final ValueChanged<String> onToggleTask;
  final ValueChanged<String> onDeleteTask;

  @override
  State<_TaskItemCard> createState() {
    return _TaskItemCardState();
  }
}

class _TaskItemCardState extends State<_TaskItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _entranceController,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
      );

  bool _isHovered = false;
  bool _isDeleteHovered = false;

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Color _priorityColor(BuildContext context) {
    return widget.priorityColorBuilder(widget.task.priority);
  }

  Color _priorityBackgroundColor(BuildContext context) {
    switch (widget.task.priority) {
      case Priority.high:
        return AppColors.highBg(context);
      case Priority.medium:
        return AppColors.mediumBg(context);
      case Priority.low:
        return AppColors.lowBg(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(context);
    final priorityBackgroundColor = _priorityBackgroundColor(context);

    // If screen width < 900px (mobile/tablet), delete is always visible.
    // If screen width >= 900px (desktop/large web), delete shows on hover only.
    final bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    final double deleteOpacity = isSmallScreen ? 1.0 : (_isHovered ? 1.0 : 0.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
              _isDeleteHovered = false;
            });
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.task.isDone ? 0.45 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.taskHover(context)
                    : AppColors.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.borderHover(context)
                      : AppColors.border(context),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onToggleTask(widget.task.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: widget.task.isDone
                            ? AppColors.accentRed
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 1.5,
                          color: widget.task.isDone
                              ? AppColors.accentRed
                              : (_isHovered
                                    ? AppColors.muted(context)
                                    : AppColors.border(context)),
                        ),
                      ),
                      child: widget.task.isDone
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: widget.task.isDone
                                ? AppColors.muted(context)
                                : AppColors.text(context),
                            decoration: widget.task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: priorityBackgroundColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: priorityColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.toLabel(widget.task.priority.name),
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.33,
                                  color: priorityColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isDeleteHovered = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isDeleteHovered = false;
                      });
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: deleteOpacity,
                      child: GestureDetector(
                        onTap: () {
                          widget.onDeleteTask(widget.task.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _isDeleteHovered
                                ? const Color(0x40C0392B)
                                : const Color(0x1AC0392B),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isDeleteHovered
                                  ? AppColors.accentRed
                                  : const Color(0x33C0392B),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.accentRed,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
