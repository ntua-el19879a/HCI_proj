import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:provider/provider.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Streaks'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Check if user data is still loading
          final user = userProvider.user;
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }


          // Check if user data is loaded and not null
          if (user == null) {
            return const Center(
              child: Text('Error: User data could not be loaded.'),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current Streak: ${user.currentStreak}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Longest Streak: ${user.longestStreak}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Total Points: ${user.points}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Completed Tasks: ${user.completedTasks}',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          );
        },
      ),
    );
  }
}