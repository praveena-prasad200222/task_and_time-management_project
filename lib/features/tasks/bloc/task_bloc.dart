import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/task_repository.dart';
import '../../../models/task_status.dart';
import '../../../models/task_priority.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  String? _currentSearchQuery;
  TaskStatus? _currentStatusFilter;
  TaskPriority? _currentPriorityFilter;
  DateTime? _currentDueDateFilter;

  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TaskInitialState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      _currentSearchQuery = event.searchQuery;
      _currentStatusFilter = event.statusFilter;
      _currentPriorityFilter = event.priorityFilter;
      _currentDueDateFilter = event.dueDateFilter;

      final tasks = await _taskRepository.getTasks(
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      );

      emit(TaskLoadedState(
        tasks: tasks,
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      ));
    } catch (e) {
      emit(TaskErrorState(message: 'Failed to load tasks: ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.addTask(event.task);
      emit(const TaskOperationSuccessState(message: 'Task created successfully'));
      add(LoadTasksEvent(
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      ));
    } catch (e) {
      emit(TaskErrorState(message: 'Failed to add task: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.updateTask(event.task);
      emit(const TaskOperationSuccessState(message: 'Task updated successfully'));
      add(LoadTasksEvent(
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      ));
    } catch (e) {
      emit(TaskErrorState(message: 'Failed to update task: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTaskStatus(UpdateTaskStatusEvent event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.updateTaskStatus(event.taskId, event.newStatus);
      emit(const TaskOperationSuccessState(message: 'Task status updated'));
      add(LoadTasksEvent(
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      ));
    } catch (e) {
      emit(TaskErrorState(message: 'Failed to update task status: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.deleteTask(event.taskId);
      emit(const TaskOperationSuccessState(message: 'Task deleted successfully'));
      add(LoadTasksEvent(
        searchQuery: _currentSearchQuery,
        statusFilter: _currentStatusFilter,
        priorityFilter: _currentPriorityFilter,
        dueDateFilter: _currentDueDateFilter,
      ));
    } catch (e) {
      emit(TaskErrorState(message: 'Failed to delete task: ${e.toString()}'));
    }
  }
}
