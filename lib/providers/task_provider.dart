import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseService dbService;

  TaskProvider(this.dbService); // Constructor to pass the DatabaseService

  List<Task> get tasks => _tasks;
  Future<void> loadTasks() async {
    _tasks = await dbService.getTasks('');
    notifyListeners();
  }

  Future<void> loadTasksForDate(DateTime date) async {
    _tasks = await dbService.getTasksForDate('', date);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await dbService.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await dbService.deleteTask(taskId);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(int taskId) async {
    Task task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}
