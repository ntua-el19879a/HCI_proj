import 'package:flutter/material.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prioritize_it/services/gps_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final DateTime? initialDate;

  const AddTaskScreen({Key? key, this.task, this.initialDate})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _locationString;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.dueDate;
      _selectedTime = widget.task!.dueDate != null
          ? TimeOfDay.fromDateTime(widget.task!.dueDate!)
          : null;
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
      DateTime? combinedDateTime;
      if (_selectedDate != null) {
        combinedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );
        if (_selectedTime != null) {
          combinedDateTime = combinedDateTime.add(
              Duration(hours: _selectedTime!.hour, minutes: _selectedTime!.minute));
        }
      }

      Position? position = await GpsService.getCurrentLocation();
      if (position != null) {
        _locationString = "${position.latitude}, ${position.longitude}";
      }

      if (widget.task == null) {
        final newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: combinedDateTime,
          isCompleted: false,
          location: _locationString,
        );

        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

        try {
          await NotificationService.showNotification(
            id: newTask.id ?? 0,
            title: 'Task Added',
            body: 'You added: ${newTask.title}',
          );
        } catch (e) {
          print("Error showing notification: $e");
        }
      } else {
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: combinedDateTime,
          isCompleted: widget.task!.isCompleted,
          location: _locationString,
        );

        Provider.of<TaskProvider>(context, listen: false)
            .updateTask(updatedTask);
      }

      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    DateTime initialDate = _selectedDate ?? DateTime.now();
    if (initialDate.isBefore(DateTime.now())) {
      initialDate = DateTime.now();
    }
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) return;
      setState(() {
        _selectedTime = pickedTime;
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
                          ? 'No Due Date'
                          : 'Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime == null
                          ? 'No Time Set'
                          : 'Time: ${DateFormat('HH:mm').format(DateTime(0, 0, 0, _selectedTime!.hour, _selectedTime!.minute))}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentTimePicker,
                    child: const Text('Choose Time'),
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