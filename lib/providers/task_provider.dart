import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseService dbService;
  List<Task> _tasks = [];

  TaskProvider(this.dbService);

  List<Task> get tasks => _tasks;

  Future<void> loadTasksForDate(String userId, DateTime date) async {
    _tasks = await dbService.getTasksForDate(userId, date);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      await dbService.insertTask(task);
      if (task.userId.isNotEmpty) {
        await loadTasksForDate(task.userId, task.date ?? DateTime.now());
      }
    } catch (e) {
      debugPrint("Error adding task: $e");
      throw e;
    }
  }

  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
    if (task.userId.isNotEmpty) {
      await loadTasksForDate(task.userId, task.date ?? DateTime.now());
    }
  }

  Future<void> deleteTask(String taskId, String userId, DateTime date) async {
    await dbService.deleteTask(taskId);
    await loadTasksForDate(userId, date);
  }

  Future<void> toggleTaskCompletion(
      String taskId, String userId, DateTime date) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await dbService.updateTask(task);
    await loadTasksForDate(userId, date);
  }
}