import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseService dbService;

  TaskProvider(this.dbService); // Constructor to pass the DatabaseService

  List<Task> get tasks => _tasks;

  Future<void> loadTasksForDate(String userId, DateTime date) async {
    _tasks = await dbService.getTasksForDate(userId, date);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await dbService.insertTask(task);
    await loadTasksForDate(task.userId, task.date!);
  }

  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
    await loadTasksForDate(task.userId, task.date!);
  }

  Future<void> deleteTask(Task task) async {
    await dbService.deleteTask(task.id!);
    await loadTasksForDate(task.userId, task.date!);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}
