import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'package:intl/intl.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/screens/google_map_screen.dart';
import 'package:prioritize_it/services/gps_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final DateTime? initialDate;

  const AddTaskScreen({Key? key, this.task, this.initialDate}) : super(key: key);

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
  String? _address; // To store the human-readable address

  @override
  void initState() {
    super.initState();
    _currentUserId =
        Provider.of<CustomAuthProvider>(context, listen: false).currentUser?.id;

    // Pre-fill fields if editing an existing task
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.date;
      _selectedTime = widget.task!.date != null
          ? TimeOfDay.fromDateTime(widget.task!.date!)
          : null;
      _selectedLocation = widget.task!.latLngLocation;
      _address = widget.task!.address;
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
          _address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      DateTime? combinedDateTime;

      // Combine date and time if both are set
      if (_selectedDate != null) {
        combinedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );

        if (_selectedTime != null) {
          combinedDateTime = combinedDateTime.add(Duration(
            hours: _selectedTime!.hour,
            minutes: _selectedTime!.minute,
          ));
        }
      }

      // Retrieve current location if none is set
      if (_selectedLocation == null) {
        try {
          Position? position = await GpsService.getCurrentLocation();
          if (position != null) {
            _selectedLocation = LatLng(position.latitude, position.longitude);
            await _getAddressFromLatLng(_selectedLocation!);
          } else {
            debugPrint("Location is null");
          }
        } catch (e) {
          debugPrint("Error getting location: $e");
        }
      }

      // Create a new task or update an existing one
      if (widget.task == null) {
        final newTask = Task(
          title: _titleController.text,
          userId: _currentUserId!,
          description: _descriptionController.text,
          date: combinedDateTime,
          isCompleted: false,
          latLngLocation: _selectedLocation,
          address: _address, // Save the address
        );

        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
        Provider.of<UserProvider>(context, listen: false).handleTaskAdded();
        try {
          await NotificationService.showNotification(
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
          address: _address, // Save the address
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime != null) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
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
          child: SingleChildScrollView(
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
                            : 'Time: ${_selectedTime!.format(context)}',
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
                        _address ?? 'No location selected',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
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
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}