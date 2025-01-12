import 'package:flutter/material.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final User? currentUser = userProvider.user;
    final currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: currentTheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  APP_NAME,
                  style: TextStyle(
                    color: currentTheme.primaryText,
                    fontSize: 24,
                  ),
                ),
                Spacer(),
                if (currentUser != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.name,
                        style: TextStyle(
                          color: currentTheme.primaryText,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: TextStyle(
                          color: currentTheme.primaryText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(HOME_TITLE),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(CALENDAR_TITLE),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text(THEMES_TITLE),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/themes');
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(STREAKS_TITLE),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/streak');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(SETTINGS_TITLE),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(LOGOUT_TITLE),
            onTap: () async {
              Provider.of<CustomAuthProvider>(context, listen: false).logOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
