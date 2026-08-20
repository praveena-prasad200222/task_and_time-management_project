import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../models/task_model.dart';
import '../../../models/task_status.dart';
import '../../../models/task_priority.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;

  const AddEditTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedUserController;

  late TaskStatus _selectedStatus;
  late TaskPriority _selectedPriority;
  late DateTime _selectedDueDate;

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _assignedUserController = TextEditingController(text: task?.assignedUser ?? '');

    _selectedStatus = task?.status ?? TaskStatus.pending;
    _selectedPriority = task?.priority ?? TaskPriority.medium;
    _selectedDueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedUserController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _selectedDueDate.isBefore(today) ? today : _selectedDueDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(_selectedDueDate.year, _selectedDueDate.month, _selectedDueDate.day);

      if (selectedDay.isBefore(today)) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: AppColors.error,
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Due date cannot be set to a past date',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }

      if (isEditing) {
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          assignedUser: _assignedUserController.text.trim(),
          status: _selectedStatus,
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
          updatedAt: now,
        );
        context.read<TaskBloc>().add(UpdateTaskEvent(task: updatedTask));
      } else {
        final newTask = TaskModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          assignedUser: _assignedUserController.text.trim(),
          status: _selectedStatus,
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
          createdAt: now,
          updatedAt: now,
        );
        context.read<TaskBloc>().add(AddTaskEvent(task: newTask));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 20, 32),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isEditing ? 'Edit Task' : 'Create Task',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: 'Task Title',
                            hint: 'Enter task title (3-60 chars)',
                            controller: _titleController,
                            maxLength: 60,
                            validator: Validators.validateTitle,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Description',
                            hint: 'Enter detailed task description (5-300 chars)',
                            controller: _descriptionController,
                            maxLines: 3,
                            maxLength: 300,
                            validator: Validators.validateDescription,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Assigned User',
                            hint: 'e.g. John Doe (2-40 chars)',
                            controller: _assignedUserController,
                            prefixIcon: const Icon(Icons.person_outline),
                            maxLength: 40,
                            validator: Validators.validateAssignedUser,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Priority',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<TaskPriority>(
                                      value: _selectedPriority,
                                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                                      items: TaskPriority.values.map((priority) {
                                        return DropdownMenuItem(
                                          value: priority,
                                          child: Text(priority.displayName),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedPriority = val);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Status',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<TaskStatus>(
                                      value: _selectedStatus,
                                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                                      items: TaskStatus.values.map((status) {
                                        return DropdownMenuItem(
                                          value: status,
                                          child: Text(status.displayName),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedStatus = val);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Due Date',
                            controller: TextEditingController(text: DateFormatter.formatDate(_selectedDueDate)),
                            readOnly: true,
                            onTap: _pickDueDate,
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: isEditing ? 'Update Task' : 'Create Task',
                            onPressed: _onSavePressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
