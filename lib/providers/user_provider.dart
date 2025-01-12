import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:prioritize_it/providers/auth_provider.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final DatabaseService dbService;
  final CustomAuthProvider authProvider;

  UserProvider(this.dbService, this.authProvider) {
    loadUser();
  }

  User? get user => _user;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<void> loadUser() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    String? currentUserId = authProvider.currentUser?.id;
    if (currentUserId != null) {
      _user = await dbService.getUserByUid(currentUserId);
      if (_user == null) {
        _user = User(name: '', uid: currentUserId, email: '', password: '');
        await dbService.insertUser(_user!);
      }
      await _checkStreak();

      // Fetch the number of completed tasks from the database
      if (_user != null && _user!.id != null) {
        _user!.completedTasks = await dbService.getCompletedTasksCount(_user!.id!);
      }
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
      await _updateLastActivityDate();
      await _checkStreak();
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
    DateTime now = DateTime.now();
    String formattedToday = DateFormat('yyyy-MM-dd').format(now);

    if (lastActivityDate != null) {
      DateTime lastDate = DateTime.parse(lastActivityDate);
      DateTime yesterday = now.subtract(Duration(days: 1));
      if (DateFormat('yyyy-MM-dd').format(lastDate) ==
          DateFormat('yyyy-MM-dd').format(yesterday)) {
        _user!.incrementStreak();
      } else if (DateFormat('yyyy-MM-dd').format(lastDate) != formattedToday) {
        _user!.resetStreak();
      }
    } else {
      _user!.resetStreak();
    }

    // Update the user in the database
    await dbService.updateUser(_user!);
    notifyListeners();
  }

  Future<void> _updateLastActivityDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedToday = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('lastActivityDate', formattedToday);
    await _checkInactivity();
  }

  Future<void> handleTaskAdded() async {
    if (_user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTask = prefs.getBool('isFirstTask') ?? true;

      if (isFirstTask) {
        _user!.addPoints(30);
        await prefs.setBool('isFirstTask', false);
      } else {
        _user!.addPoints(10);
      }

      await _updateLastActivityDate();
      await _checkStreak();
      await dbService.updateUser(_user!);
      notifyListeners();
    }
  }

  Future<void> _checkInactivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastActivityDate = prefs.getString('lastActivityDate');
    DateTime now = DateTime.now();

    if (lastActivityDate != null) {
      DateTime lastActive = DateTime.parse(lastActivityDate);
      int daysInactive = now.difference(lastActive).inDays;

      if (daysInactive >= 2) {
        int pointsToDeduct = (daysInactive ~/ 2) * 50;
        _user!.deductPoints(pointsToDeduct);
        await dbService.updateUser(_user!);
        notifyListeners();
      }
    }
  }
}