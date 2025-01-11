import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _database;

  // Collections
  static const String _tasksCollection = 'tasks';
  static const String _usersCollection = 'users';

  DatabaseService({FirebaseFirestore? firestore})
      : _database = firestore ?? FirebaseFirestore.instance;

  // --- User Methods ---

  Future<User?> getUserByUid(String uid) async {
    final querySnapshot = await _database
        .collection(_usersCollection)
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;

    return User.fromMap(doc.data()..['id'] = doc.id);
  }

  // Insert a new user
  Future<User> insertUser(User user) async {
    final docRef =
    await _database.collection(_usersCollection).add(user.toMap());
    final docId = docRef.id;
    User createdUser = User.fromMap({...user.toMap(), 'id': docId});
    return createdUser;
  }

  // Update an existing user
  Future<void> updateUser(User user) async {
    await _database
        .collection(_usersCollection)
        .doc(user.id)
        .update(user.toMap());
  }

  // --- Task Methods ---

  // Get tasks for a specific date
  Future<List<Task>> getTasksForDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
    final endOfDay =
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999).toUtc();

    final querySnapshot = await _database
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .get();

    return querySnapshot.docs
        .map((doc) => Task.fromMap({
      ...doc.data(),
      'id': doc.id,
    }))
        .toList();
  }

  // Insert a new task
  Future<void> insertTask(Task task) async {
    await _database.collection(_tasksCollection).add(task.toMap());
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _database.collection(_tasksCollection).doc(task.id).update(task.toMap());
    } catch (e) {
      debugPrint("Error updating task: $e");
      throw e;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _database.collection(_tasksCollection).doc(taskId).delete();
  }

  Future<int> getCompletedTasksCount(String userId) async {
    final querySnapshot = await _database
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .where('isCompleted', isEqualTo: true)
        .get();

    return querySnapshot.docs.length;
  }
}