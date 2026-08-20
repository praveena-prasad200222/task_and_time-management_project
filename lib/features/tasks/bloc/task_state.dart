import 'package:equatable/equatable.dart';
import '../../../models/task_model.dart';
import '../../../models/task_status.dart';
import '../../../models/task_priority.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<TaskModel> tasks;
  final String? searchQuery;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final DateTime? dueDateFilter;

  const TaskLoadedState({
    required this.tasks,
    this.searchQuery,
    this.statusFilter,
    this.priorityFilter,
    this.dueDateFilter,
  });

  int get totalCount => tasks.length;
  int get pendingCount => tasks.where((t) => t.status == TaskStatus.pending).length;
  int get inProgressCount => tasks.where((t) => t.status == TaskStatus.inProgress).length;
  int get completedCount => tasks.where((t) => t.status == TaskStatus.completed).length;

  bool get hasActiveFilter =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      statusFilter != null ||
      priorityFilter != null ||
      dueDateFilter != null;

  @override
  List<Object?> get props => [
        tasks,
        searchQuery,
        statusFilter,
        priorityFilter,
        dueDateFilter,
      ];
}

class TaskErrorState extends TaskState {
  final String message;

  const TaskErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccessState extends TaskState {
  final String message;

  const TaskOperationSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
