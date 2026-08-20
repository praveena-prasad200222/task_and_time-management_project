import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1_interview/core/utils/validators.dart';
import 'package:flutter_application_1_interview/models/task_model.dart';
import 'package:flutter_application_1_interview/models/task_status.dart';
import 'package:flutter_application_1_interview/models/task_priority.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Email validator returns error on empty email', () {
      final result = Validators.validateEmail('');
      expect(result, 'Email is required');
    });

    test('Email validator returns error on invalid email format', () {
      final result = Validators.validateEmail('invalid-email');
      expect(result, 'Please enter a valid email address');
    });

    test('Email validator returns null on valid email', () {
      final result = Validators.validateEmail('admin@example.com');
      expect(result, isNull);
    });

    test('Password validator returns error if shorter than 6 characters', () {
      final result = Validators.validatePassword('123');
      expect(result, 'Password must be at least 6 characters');
    });
  });

  group('Task Model & Enums Unit Tests', () {
    test('TaskStatus displayName returns correct string', () {
      expect(TaskStatus.pending.displayName, 'Pending');
      expect(TaskStatus.inProgress.displayName, 'In Progress');
      expect(TaskStatus.completed.displayName, 'Completed');
    });

    test('TaskPriority displayName returns correct string', () {
      expect(TaskPriority.low.displayName, 'Low');
      expect(TaskPriority.medium.displayName, 'Medium');
      expect(TaskPriority.high.displayName, 'High');
    });

    test('TaskModel copyWith updates fields correctly', () {
      final now = DateTime.now();
      final task = TaskModel(
        id: '1',
        title: 'Original Title',
        description: 'Desc',
        status: TaskStatus.pending,
        priority: TaskPriority.low,
        assignedUser: 'User 1',
        dueDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final updatedTask = task.copyWith(
        title: 'Updated Title',
        status: TaskStatus.completed,
      );

      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.status, TaskStatus.completed);
      expect(updatedTask.id, '1');
    });
  });
}
