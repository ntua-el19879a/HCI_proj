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
    try {
      final querySnapshot = await _database
          .collection(_usersCollection)
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return User.fromMap(data);
    } catch (e) {
      debugPrint('Stack trace: $e');
      debugPrint("Error fetching user by UID: $e");
      return null;
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final docSnapshot = await _database.collection('users').doc(id).get();
      if (!docSnapshot.exists) return null;
      return User.fromMap(docSnapshot.data()!..['id'] = docSnapshot.id);
    } catch (e) {
      debugPrint("Error fetching user by ID: $e");
      return null;
    }
  }

  // Insert a new user
  Future<User> insertUser(User user) async {
    try {
      final docRef =
          await _database.collection(_usersCollection).add(user.toMap());
      final docId = docRef.id;
      User createdUser = User.fromMap({...user.toMap(), 'id': docId});
      return createdUser;
    } catch (e) {
      debugPrint("Error inserting user: $e");
      rethrow;
    }
  }

  // Update an existing user
  Future<void> updateUser(User user) async {
    try {
      await _database
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      debugPrint("Error updating user: $e");
      rethrow;
    }
  }

  // --- Task Methods ---

  // Get tasks for a specific date
  Future<List<Task>> getTasksForDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
    final endOfDay =
        DateTime(date.year, date.month, date.day, 23, 59, 59, 999).toUtc();

    try {
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
    } catch (e) {
      debugPrint("Error getting tasks for date: $e");
      rethrow;
    }
  }

  // Insert a new task
  Future<void> insertTask(Task task) async {
    try {
      await _database.collection(_tasksCollection).add(task.toMap());
    } catch (e) {
      debugPrint("Error inserting task: $e");
      rethrow;
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _database
          .collection(_tasksCollection)
          .doc(task.id)
          .update(task.toMap());
    } catch (e) {
      debugPrint("Error updating task: $e");
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _database.collection(_tasksCollection).doc(taskId).delete();
    } catch (e) {
      debugPrint("Error deleting task: $e");
      rethrow;
    }
  }

  // Get the count of completed tasks for a user
  Future<int> getCompletedTasksCount(String userId) async {
    try {
      final querySnapshot = await _database
          .collection(_tasksCollection)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: true)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      debugPrint("Error getting completed tasks count: $e");
      rethrow;
    }
  }
}
