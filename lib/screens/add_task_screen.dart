import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prioritize_it/services/gps_service.dart';
import 'package:prioritize_it/services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _locationString;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Editing an existing task
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.dueDate;
      _locationString = widget.task!.location;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Get location if user has enabled it
      Position? position = await GpsService.getCurrentLocation();
      if (position != null) {
        _locationString = "${position.latitude}, ${position.longitude}";
      }

      if (widget.task == null) {
        // Adding a new task
        final newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          isCompleted: false,
          location: _locationString,
        );

        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

        // Show notification
        try {
          await NotificationService.showNotification(
            id: newTask.id ?? 0,
            title: 'Task Added',
            body: 'You added: ${newTask.title}',
          );
        } catch (e) {
          print("Error showing notification: $e");
          // Handle the error, e.g., show a message to the user
        }
      } else {
        // Updating an existing task
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          isCompleted: widget.task!.isCompleted,
          location: _locationString,
        );

        Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
      }

      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : 'Due Date: ${_selectedDate.toString()}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}