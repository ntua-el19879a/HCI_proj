import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class BaseLayout extends StatelessWidget {
  final Widget title;
  final Widget body;
  final Widget? floatingActionButton;

  const BaseLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Prioritize-It',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Themes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/themes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Streaks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/streak');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final authProvider =
                    Provider.of<CustomAuthProvider>(context, listen: false);
                await authProvider.logOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
