import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
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
                'Due Date: ${DateFormat('yyyy-dd-MM').format(task.date!)}'
                '${task.date!.hour != 0 || task.date!.minute != 0 ? ' ' + DateFormat('HH:mm').format(task.date!) : ''}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 10),
            if (task.location != null)
              Text(
                'Location: ${task.location}',
                style: const TextStyle(fontSize: 18),
              ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
