import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;

  const TaskItem({Key? key, required this.task, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          Provider.of<TaskProvider>(context, listen: false)
              .toggleTaskCompletion(task.id!);
        },
      ),
      title: Text(task.title),
      subtitle: task.dueDate != null ? Text('Due: ${task.dueDate}') : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id!);
            },
          ),
        ],
      ),
    );
  }
}