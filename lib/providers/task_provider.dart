import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Load tasks from the database
  Future<void> loadTasks() async {
    _tasks = await DatabaseService.getTasks();
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await DatabaseService.insertTask(task);
    await loadTasks(); // Reload tasks after adding
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await DatabaseService.updateTask(task);
    await loadTasks();
  }

  // Delete a task
  Future<void> deleteTask(int taskId) async {
    await DatabaseService.deleteTask(taskId);
    await loadTasks();
  }

  // Mark a task as complete/incomplete
  Future<void> toggleTaskCompletion(int taskId) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

// ... other methods for filtering, sorting tasks, etc.
}