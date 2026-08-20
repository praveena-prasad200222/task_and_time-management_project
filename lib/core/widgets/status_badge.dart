import 'package:flutter/material.dart';
import '../../models/task_status.dart';
import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status) {
      case TaskStatus.pending:
        bg = AppColors.pendingBg;
        text = AppColors.pending;
        break;
      case TaskStatus.inProgress:
        bg = AppColors.inProgressBg;
        text = AppColors.inProgress;
        break;
      case TaskStatus.completed:
        bg = AppColors.completedBg;
        text = AppColors.completed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
