import 'package:flutter/material.dart';
import '../../models/task_status.dart';
import '../../models/task_priority.dart';
import '../constants/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final TaskStatus? initialStatus;
  final TaskPriority? initialPriority;
  final Function(TaskStatus? status, TaskPriority? priority) onApply;

  const FilterBottomSheet({
    super.key,
    this.initialStatus,
    this.initialPriority,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  TaskStatus? selectedStatus;
  TaskPriority? selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    selectedPriority = widget.initialPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedStatus = null;
                    selectedPriority = null;
                  });
                },
                child: const Text('Reset All', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedStatus == null,
                onSelected: (_) => setState(() => selectedStatus = null),
              ),
              ...TaskStatus.values.map((status) {
                return FilterChip(
                  label: Text(status.displayName),
                  selected: selectedStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      selectedStatus = selected ? status : null;
                    });
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedPriority == null,
                onSelected: (_) => setState(() => selectedPriority = null),
              ),
              ...TaskPriority.values.map((priority) {
                return FilterChip(
                  label: Text(priority.displayName),
                  selected: selectedPriority == priority,
                  onSelected: (selected) {
                    setState(() {
                      selectedPriority = selected ? priority : null;
                    });
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(selectedStatus, selectedPriority);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
