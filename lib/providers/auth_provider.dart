import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/services/database_service.dart';

class CustomAuthProvider with ChangeNotifier {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final DatabaseService _databaseService;
  User? _currentUser;

  CustomAuthProvider(
      this._databaseService, {
        fbAuth.FirebaseAuth? firebaseAuth,
      }) : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance;

  User? get currentUser => _currentUser;

  Future<void> checkUserLoggedIn() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null) {
      // If user is already logged in, fetch user details from the database
      _currentUser = await _databaseService.getUserByUid(fbUser.uid);
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = userCredential.user;
      if (fbUser != null) {
        final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        final newUser = User(
            uid: fbUser.uid,
            name: name,
            email: email,
            password: hashedPassword);
        _currentUser = await _databaseService.insertUser(newUser);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = userCredential.user;
      if (fbUser != null) {
        _currentUser = await _databaseService.getUserByUid(fbUser.uid);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}