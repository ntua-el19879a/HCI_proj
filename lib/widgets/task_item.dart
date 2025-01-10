import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;

  const TaskItem({Key? key, required this.task, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Check if the task's due date is in the future
    final isFutureTask = task.date != null && task.date!.isAfter(now);

    // Check if the task's due date is in the past
    final isPastTask = task.date != null &&
        task.date!.isBefore(DateTime(now.year, now.month, now.day));

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: isPastTask || isFutureTask
            ? null
            : (bool? newValue) {
          if (newValue != null) {
            Provider.of<TaskProvider>(context, listen: false)
                .toggleTaskCompletion(task.id!, task.userId, task.date!);
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
              onPressed: onEdit,
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id!, task.userId, task.date!);
            },
          ),
        ],
      ),
    );
  }
}