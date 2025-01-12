import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final DatabaseService dbService;

  UserProvider(this.dbService);

  User? get user => _user;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<void> loadUser() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    _user = await dbService.getUserByUid('');
    if (_user == null) {
      _user = User(name: '', uid: '', email: '', password: '');
      await dbService.insertUser(_user!);
    }
    await _checkStreak();

    // Fetch the number of completed tasks from the database
    if (_user != null && _user!.id != null) {
      _user!.completedTasks = await dbService.getCompletedTasksCount(_user!.id!);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    await dbService.updateUser(updatedUser);
    _user = updatedUser; // Update local user object
    notifyListeners(); // Notify after updating
  }

  Future<void> handleTaskCompletion(int pointsAwarded) async {
    if (_user != null) {
      _user!.addPoints(pointsAwarded);
      _user!.incrementCompletedTasks();
      await _updateStreak();
      await dbService.updateUser(_user!);
      notifyListeners();
    }
  }

  Future<void> handleTaskUncompletion() async {
    if (_user != null ) {
      _user!.deductPoints(30);
      _user!.decrementCompletedTasks();
      await dbService.updateUser(_user!);
      notifyListeners();
    }
  }

  Future<void> handleTaskFailure(int pointsDeducted) async {
    if (_user != null) {
      _user!.deductPoints(pointsDeducted);
      await dbService.updateUser(_user!); // Update in database
      notifyListeners(); // Notify after updating
    }
  }

  Future<void> _checkStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastActivityDate = prefs.getString('lastActivityDate');
    bool isFirstTask = prefs.getBool('isFirstTask') ??
        true; // Check if it's the first task today

    if (isFirstTask) {
      // Award points for the first task of the day
      _user?.addPoints(30); // 30 points for the first task
      await dbService.updateUser(_user!);
      await prefs.setBool('isFirstTask', false);
    }

    if (lastActivityDate != null) {
      DateTime lastDate = DateTime.parse(lastActivityDate);
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      if (DateFormat('yyyy-dd-MM').format(lastDate) ==
          DateFormat('yyyy-dd-MM').format(yesterday)) {
        _user!.incrementStreak();
      } else if (DateFormat('yyyy-dd-MM').format(lastDate) !=
          DateFormat('yyyy-dd-MM').format(DateTime.now())) {
        _user!.resetStreak();
      }
    } else {
      _user!.resetStreak();
    }

    await prefs.setString(
        'lastActivityDate', DateFormat('yyyy-dd-MM').format(DateTime.now()));
  }

  Future<void> _updateStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastActivityDate', DateFormat('yyyy-dd-MM').format(DateTime.now()));
    await _checkStreak(); // Update streak data after updating activity date
  }

  Future<void> handleTaskAdded() async {
    if (_user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTask = prefs.getBool('isFirstTask') ?? true;

      // Check if it's the first task of the day
      if (isFirstTask) {
        // Award points for the first task of the day
        _user!.addPoints(30); // 30 points for the first task
        await prefs.setBool('isFirstTask', false);
      } else {
        _user!.addPoints(10);
      }
      // Update streak and user in the database
      await _updateStreak();
      await dbService.updateUser(_user!);
      notifyListeners(); // Notify after updating
    }
  }
}