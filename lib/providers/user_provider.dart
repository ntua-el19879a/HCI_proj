import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/services/database_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Load user data from the database
  Future<void> loadUser() async {
    _user = await DatabaseService.getUser();
    if (_user == null) {
      // If no user exists, create a default one and save it
      _user = User();
      await DatabaseService.insertUser(_user!);
    }
    notifyListeners();
  }

  // Update user data (streak, points, etc.)
  Future<void> updateUser(User updatedUser) async {
    await DatabaseService.updateUser(updatedUser);
    await loadUser(); // Reload user data after update
  }

  // Example method to handle task completion (update user data)
  Future<void> handleTaskCompletion(int pointsAwarded) async {
    if (_user != null) {
      _user!.incrementStreak();
      _user!.addPoints(pointsAwarded);
      _user!.incrementCompletedTasks();
      await updateUser(_user!);
    }
  }

  // Example method to handle task failure/missed deadline (update user data)
  Future<void> handleTaskFailure(int pointsDeducted) async {
    if (_user != null) {
      _user!.resetStreak();
      _user!.deductPoints(pointsDeducted);
      await updateUser(_user!);
    }
  }
}