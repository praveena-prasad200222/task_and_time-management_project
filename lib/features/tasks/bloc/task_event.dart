import 'package:equatable/equatable.dart';
import '../../../models/task_model.dart';
import '../../../models/task_status.dart';
import '../../../models/task_priority.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String? searchQuery;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final DateTime? dueDateFilter;

  const LoadTasksEvent({
    this.searchQuery,
    this.statusFilter,
    this.priorityFilter,
    this.dueDateFilter,
  });

  @override
  List<Object?> get props => [searchQuery, statusFilter, priorityFilter, dueDateFilter];
}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;

  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final TaskStatus newStatus;

  const UpdateTaskStatusEvent({required this.taskId, required this.newStatus});

  @override
  List<Object?> get props => [taskId, newStatus];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
