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
    await dbService.insertTask(task);
    if (task.userId.isNotEmpty && task.date != null) {
      await loadTasksForDate(task.userId, task.date!);
    }
  }

  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
    if (task.userId.isNotEmpty && task.date != null) {
      await loadTasksForDate(task.userId, task.date!);
    }
  }

  Future<void> deleteTask(String taskId, String userId, DateTime date) async {
    await dbService.deleteTask(taskId);
    await loadTasksForDate(userId, date);
  }

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
    await loadTasksForDate(userId, date);
  }
}