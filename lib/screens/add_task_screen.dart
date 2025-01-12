import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';

import 'package:prioritize_it/screens/google_map_screen.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:prioritize_it/widgets/buttons/styeld_elevated_button.dart';
import 'package:prioritize_it/widgets/buttons/styled_text_button.dart';
import 'package:prioritize_it/widgets/styled_app_bar.dart';
import 'package:provider/provider.dart';
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
  late String? _currentUserId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _currentUserId =
        Provider.of<CustomAuthProvider>(context, listen: false).currentUser?.id;

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.date;
      _selectedTime = widget.task!.date != null
          ? TimeOfDay.fromDateTime(widget.task!.date!)
          : null;
      _selectedLocation = widget.task!.latLngLocation;
      _selectedAddress = widget.task!.address;
    } else {
      _selectedDate = widget.initialDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _selectedAddress =
          '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  bool _isPastTask() {
    if (widget.task == null || widget.task!.date == null) {
      return false; // Not an existing task or no due date, so not a past task
    }

    final now = DateTime.now();
    final taskDate = widget.task!.date!;
    return taskDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      DateTime? combinedDateTime = _selectedDate;
      if (_selectedTime != null && _selectedDate != null) {
        combinedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      }

      if (_selectedLocation != null && _selectedAddress == null) {
        await _getAddressFromLatLng(_selectedLocation!);
      }

      if (widget.task == null) {
        final newTask = Task(
          title: _titleController.text,
          userId: _currentUserId!,
          description: _descriptionController.text,
          date: combinedDateTime,
          isCompleted: false,
          latLngLocation: _selectedLocation,
          address: _selectedAddress,
        );

        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
        Provider.of<UserProvider>(context, listen: false).handleTaskAdded();
        try {
          NotificationService.showNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: 'Task Added',
            body: 'You added: ${newTask.title}',
          );
        } catch (e) {
          debugPrint("Error showing notification: $e");
        }
      } else {
        final updatedTask = Task(
          id: widget.task!.id,
          userId: _currentUserId!,
          title: _titleController.text,
          description: _descriptionController.text,
          date: combinedDateTime,
          isCompleted: widget.task!.isCompleted,
          latLngLocation: _selectedLocation,
          address: _selectedAddress,
        );

        Provider.of<TaskProvider>(context, listen: false)
            .updateTask(updatedTask);
      }

      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    DateTime initialDate = _selectedDate ?? DateTime.now();
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
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
    final isPastTask = _isPastTask();
    AppTheme currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      appBar: StyledAppBar(
          title: widget.task == null ? NEW_TASK_TITLE : widget.task!.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  enabled: !isPastTask, // Disable if it's a past task
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
                  enabled: !isPastTask,
                  maxLines: 1,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedAddress == null
                            ? 'No location selected'
                            : 'Location: $_selectedAddress',
                      ),
                    ),
                    StyledTextButton(
                      onPressed: isPastTask
                          ? null
                          : () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoogleMapScreen(
                              initialLocation: _selectedLocation,
                              onLocationSelected: (LatLng location) async {
                                setState(() {
                                  _selectedLocation = location;
                                });
                                await _getAddressFromLatLng(location);
                              },
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedLocation = result;
                          });
                          await _getAddressFromLatLng(result);
                        }
                      },
                      child: const Text('Select Location'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StyledElevatedButton(
                  onPressed: isPastTask ? null : _submitData,
                  child:
                  Text(widget.task == null ? 'Add Task' : 'Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}