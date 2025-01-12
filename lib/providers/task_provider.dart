import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/providers/auth_provider.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseService dbService;
  final CustomAuthProvider authProvider;
  List<Task> _tasks = [];

  TaskProvider(this.dbService, this.authProvider);

  List<Task> get tasks => _tasks;

  // Load tasks for a specific user and date
  Future<void> loadTasksForDate(String userId, DateTime date) async {
    _tasks = await dbService.getTasksForDate(userId, date);
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await dbService.insertTask(task);
    // Reload tasks for the current user and selected date
    if (task.userId.isNotEmpty && task.date != null) {
      await loadTasksForDate(task.userId, task.date!);
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
    // Reload tasks for the current user and selected date
    if (task.userId.isNotEmpty && task.date != null) {
      await loadTasksForDate(task.userId, task.date!);
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId, String userId, DateTime date) async {
    await dbService.deleteTask(taskId);
    // Reload tasks for the current user and selected date
    await loadTasksForDate(userId, date);
  }

  // Toggle the completion status of a task
  Future<void> toggleTaskCompletion(
      String taskId, String userId, DateTime date) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId,
        orElse: () => Task(id: '', title: '', userId: '', isCompleted: false));
    if (task.id == null || task.id!.isEmpty) {
      print("Task not found in the list");
      return;
    }

    task.isCompleted = !task.isCompleted;
    await dbService.updateTask(task);
    // Reload tasks for the current user and selected date
    await loadTasksForDate(userId, date);
  }
}