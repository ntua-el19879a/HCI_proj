import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/widgets/styled_app_bar.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        title: 'Task Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (task.description != null)
              Text(
                'Description: ${task.description}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 10),
            if (task.date != null)
              Text(
                'Date: ${DateFormat('yyyy-dd-MM').format(task.date!)}',
                style: const TextStyle(fontSize: 18),
              ),
            if (task.date != null &&
                (task.date!.hour != 0 || task.date!.minute != 0))
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Time: ${DateFormat('HH:mm').format(task.date!)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 10),
            if (task.address != null)
              Text(
                'Location: ${task.address}',
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
