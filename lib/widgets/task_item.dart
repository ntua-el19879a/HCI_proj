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
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? newValue) {
          if (newValue != null) {
            Provider.of<TaskProvider>(context, listen: false)
                .toggleTaskCompletion(task.id!, task.userId, task.date!);
          }
        },
      ),
      title: Text(task.title),
      subtitle: task.date != null &&
          (task.date!.hour != 0 || task.date!.minute != 0)
          ? Text(
        'Time: ${DateFormat('HH:mm').format(task.date!)}',
      )
          : null,
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