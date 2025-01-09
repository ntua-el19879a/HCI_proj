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
                'Time: ${DateFormat('HH:mm').format(task.date!)}',
                style: const TextStyle(fontSize: 18),
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