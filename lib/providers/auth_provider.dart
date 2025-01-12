import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/utils/theme_name.dart';

class CustomAuthProvider with ChangeNotifier {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final DatabaseService _databaseService;
  final UserProvider userProvider;
  String? _currentUserId;

  CustomAuthProvider(
    this._databaseService,
    this.userProvider, {
    fbAuth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance;

  String? get currentUserId => _currentUserId;

  Future<void> getUser() async {
    userProvider.user = await _databaseService.getUserById(currentUserId ?? '');
    notifyListeners();
  }

  Future<void> checkUserLoggedIn() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null) {
      // If user is already logged in, fetch user details from the database
      User? user = await _databaseService.getUserByUid(fbUser.uid);
      if (user != null) {
        _currentUserId = user.id;
        await getUser();
      }
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
            password: hashedPassword,
            unlockedThemes: defualtUnlockedThemes);
        User user = await _databaseService.insertUser(newUser);
        _currentUserId = user.id;
        await getUser();
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
        User? user = await _databaseService.getUserByUid(fbUser.uid);
        if (user != null) {
          _currentUserId = user.id;
          await getUser();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    _currentUserId = null;
    notifyListeners();
  }
}
