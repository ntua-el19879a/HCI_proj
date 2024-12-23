import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await DatabaseService.getTasks();
    notifyListeners();
  }

  Future<void> loadTasksForDate(DateTime date) async {
    _tasks = await DatabaseService.getTasksForDate(date);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseService.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseService.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int taskId) async {
    await DatabaseService.deleteTask(taskId);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(int taskId) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}