import 'package:flutter/material.dart';

class User {
  String? id;
  String uid;
  String name;
  int currentStreak;
  int longestStreak;
  int points;
  String password;
  String email;
  int completedTasks;

  User({
    this.id,
    required this.name,
    required this.uid,
    required this.email,
    required this.password,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.points = 0,
    this.completedTasks = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'password': password,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'points': points,
      'completedTasks': completedTasks,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      uid: map['uid'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      currentStreak: map['currentStreak'],
      longestStreak: map['longestStreak'],
      points: map['points'],
      completedTasks: map['completedTasks'],
    );
  }

  void incrementStreak() {
    currentStreak++;
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  void resetStreak() {
    currentStreak = 0;
  }

  void addPoints(int amount) {
    points += amount;
  }

  void deductPoints(int amount) {
    points -= amount;
    if (points < 0) {
      points = 0;
    }
  }

  void incrementCompletedTasks() {
    completedTasks++;
  }

  void decrementCompletedTasks() {
    if (completedTasks > 0) {
      completedTasks--;
    }
  }
}