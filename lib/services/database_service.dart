import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:intl/intl.dart';

// firebase anti gia sqlite

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'prioritize_it.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String _tasksTable = 'tasks';
  static const String _userTable = 'user';

  // Task Table Columns
  static const String _taskIdColumn = 'id';
  static const String _taskTitleColumn = 'title';
  static const String _taskDescriptionColumn = 'description';
  static const String _taskDueDateColumn = 'dueDate';
  static const String _taskIsCompletedColumn = 'isCompleted';
  static const String _taskLocationColumn = 'location';
  static const String _taskPriorityColumn = 'priority';

  // User Table Columns
  static const String _userIdColumn = 'id';
  static const String _userNameColumn = 'name';
  static const String _userCurrentStreakColumn = 'currentStreak';
  static const String _userLongestStreakColumn = 'longestStreak';
  static const String _userPointsColumn = 'points';
  static const String _userCompletedTasksColumn = 'completedTasks';

  // Initialize the database
  static Future<void> initialize() async {
    if (_database != null) return;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the tables
  static Future<void> _onCreate(Database db, int version) async {
    // Create Tasks Table
    await db.execute('''
      CREATE TABLE $_tasksTable (
        $_taskIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $_taskTitleColumn TEXT NOT NULL,
        $_taskDescriptionColumn TEXT,
        $_taskDueDateColumn TEXT,
        $_taskIsCompletedColumn INTEGER NOT NULL,
        $_taskLocationColumn TEXT,
        $_taskPriorityColumn INTEGER
      )
    ''');

    // Create User Table
    await db.execute('''
      CREATE TABLE $_userTable (
        $_userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $_userNameColumn TEXT,
        $_userCurrentStreakColumn INTEGER NOT NULL,
        $_userLongestStreakColumn INTEGER NOT NULL,
        $_userPointsColumn INTEGER NOT NULL,
        $_userCompletedTasksColumn INTEGER NOT NULL
      )
    ''');
  }

  // --- User Table Methods ---

  // Get the user
  static Future<User?> getUser() async {
    final List<Map<String, dynamic>> maps = await _database!.query(_userTable);

    if (maps.isEmpty) {
      return null; // No user found
    }

    // Assuming you only store one user, get the first one
    return User.fromMap(maps.first);
  }

  // Insert a user
  static Future<int> insertUser(User user) async {
    return await _database!.insert(_userTable, user.toMap());
  }

  // Update the user
  static Future<int> updateUser(User user) async {
    return await _database!.update(
      _userTable,
      user.toMap(),
      where: '$_userIdColumn = ?',
      whereArgs: [user.id],
    );
  }

  // --- Task Table Methods ---

  // Get all tasks
  static Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await _database!.query(_tasksTable);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Get tasks for a specific date
  static Future<List<Task>> getTasksForDate(DateTime date) async {
    final startDate =
    DateTime(date.year, date.month, date.day, 0, 0, 0).toIso8601String();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59)
        .toIso8601String();

    final List<Map<String, dynamic>> maps = await _database!.query(
      _tasksTable,
      where: '$_taskDueDateColumn BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Insert a task
  static Future<int> insertTask(Task task) async {
    return await _database!.insert(_tasksTable, task.toMap());
  }

  // Update a task
  static Future<int> updateTask(Task task) async {
    return await _database!.update(
      _tasksTable,
      task.toMap(),
      where: '$_taskIdColumn = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  static Future<int> deleteTask(int id) async {
    return await _database!.delete(
      _tasksTable,
      where: '$_taskIdColumn = ?',
      whereArgs: [id],
    );
  }
}