import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/widgets/buttons/styeld_elevated_button.dart';
import 'package:prioritize_it/widgets/buttons/styled_text_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggle;

  const LoginScreen({super.key, required this.toggle});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    try {
      await authProvider.logIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          StyledElevatedButton(onPressed: login, child: Text('Login')),
          StyledTextButton(
              onPressed: widget.toggle,
              child: Text('Don\'t have an account? Register')),
        ],
      ),
    );
  }
}
