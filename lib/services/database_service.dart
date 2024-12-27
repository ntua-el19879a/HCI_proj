import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _database;

  // Collections
  static const String _tasksCollection = 'tasks';
  static const String _usersCollection = 'users';

  DatabaseService({FirebaseFirestore? firestore})
      : _database = firestore ?? FirebaseFirestore.instance;

  // --- User Methods ---

  // Get the user by ID
  Future<User?> getUser(String userId) async {
    final docSnapshot =
        await _database.collection(_usersCollection).doc(userId).get();
    if (!docSnapshot.exists) return null;

    return User.fromMap(docSnapshot.data()!);
  }

  // Insert a new user
  Future<void> insertUser(User user) async {
    await _database.collection(_usersCollection).doc(user.id).set(user.toMap());
  }

  // Update an existing user
  Future<void> updateUser(User user) async {
    await _database
        .collection(_usersCollection)
        .doc(user.id)
        .update(user.toMap());
  }

  // --- Task Methods ---

  // Get all tasks for a user
  Future<List<Task>> getTasks(String userId) async {
    final querySnapshot = await _database
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  // Get tasks for a specific date
  Future<List<Task>> getTasksForDate(String userId, DateTime date) async {
    final startDate =
        DateTime(date.year, date.month, date.day, 0, 0, 0).toIso8601String();
    final endDate =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

    final querySnapshot = await _database
        .collection(_tasksCollection)
        .where('userId', isEqualTo: userId)
        .where('dueDate', isGreaterThanOrEqualTo: startDate)
        .where('dueDate', isLessThanOrEqualTo: endDate)
        .get();

    return querySnapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  // Insert a new task
  Future<void> insertTask(Task task) async {
    await _database.collection(_tasksCollection).doc(task.id).set(task.toMap());
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _database
        .collection(_tasksCollection)
        .doc(task.id)
        .update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _database.collection(_tasksCollection).doc(taskId).delete();
  }
}
