//task_item.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/audio_service.dart';
import 'package:prioritize_it/utils/global_settings.dart';
import 'package:prioritize_it/services/notification_service.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;

  const TaskItem({Key? key, required this.task, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;
    final now = DateTime.now();
    // Check if the task's due date is in the future
    final isFutureTask = task.date != null && task.date!.isAfter(now);

    // Check if the task's due date is in the past
    final isPastTask = task.date != null &&
        task.date!.isBefore(DateTime(now.year, now.month, now.day));

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        activeColor: theme.primary,
        checkColor: theme.primaryText,
        onChanged: isPastTask || isFutureTask
            ? null
            : (bool? newValue) async {
                if (newValue != null) {
                  HapticFeedback.lightImpact();
                  Provider.of<TaskProvider>(context, listen: false)
                      .toggleTaskCompletion(task.id!, task.userId, task.date!);
                  if (newValue) {
                    if (GlobalSettings.soundEffects) {
                      AudioService.playCompletionSound();
                    }
                    await Provider.of<UserProvider>(context, listen: false).handleTaskCompletion(30);
                    if (GlobalSettings.showNotifications) {
                      NotificationService.showInstantNotification(
                          "Task completed",
                          '${task.title} was successfully completed');
                    }
                  }
                  else {
                    await Provider.of<UserProvider>(context, listen: false)
                        .handleTaskUncompletion();
                  }
                }
              },
      ),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.date != null &&
              (task.date!.hour != 0 || task.date!.minute != 0))
            Text(
              'Time: ${DateFormat('HH:mm').format(task.date!)}',
            ),
          if (task.address != null && task.address!.isNotEmpty)
            Text(
              'Location: ${task.address}',
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                HapticFeedback.lightImpact();
                onEdit!();
              },
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (GlobalSettings.soundEffects) {
                AudioService.playDeletionSound();
              }
              HapticFeedback.lightImpact();
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id!, task.userId, task.date!);
            },
          ),
        ],
      ),
    );
  }
}
