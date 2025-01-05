import 'package:flutter/material.dart';
import 'package:prioritize_it/screens/login_screen.dart';
import 'package:prioritize_it/screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: isLogin
          ? LoginScreen(toggle: toggle)
          : RegisterScreen(toggle: toggle),
    );
  }

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
