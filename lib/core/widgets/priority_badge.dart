import 'package:flutter/material.dart';
import '../../models/task_priority.dart';
import '../constants/app_colors.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (priority) {
      case TaskPriority.low:
        bg = AppColors.priorityLowBg;
        text = AppColors.priorityLow;
        break;
      case TaskPriority.medium:
        bg = AppColors.priorityMediumBg;
        text = AppColors.priorityMedium;
        break;
      case TaskPriority.high:
        bg = AppColors.priorityHighBg;
        text = AppColors.priorityHigh;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${priority.displayName} Priority',
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
