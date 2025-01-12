import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prioritize_it/models/task.dart';
import 'package:prioritize_it/models/user.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/screens/add_task_screen.dart';
import 'package:prioritize_it/screens/task_detail_screen.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:prioritize_it/widgets/task_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const HomeScreen({super.key, this.selectedDate});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  String? _currentUserId;
  AppTheme? _currentTheme;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasksForSelectedDate();
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _currentTheme = themeProvider.currentTheme;
    _currentUser = userProvider.user;
    _currentUserId = _currentUser?.id;
  }

  Future<void> _loadTasksForSelectedDate() async {
    if (_currentUserId != null && mounted) {
      await Provider.of<TaskProvider>(context, listen: false)
          .loadTasksForDate(_currentUserId!, _selectedDate);
    }
  }

  void _changeDate(int days) {
    if (mounted) {
      setState(() {
        _selectedDate = _selectedDate.add(Duration(days: days));
      });
    }
    _loadTasksForSelectedDate();
  }

  bool _isPastDate() {
    final now = DateTime.now();
    return _selectedDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  void _showTaskDetailsDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TaskDetailScreen(task: task),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = _selectedDate.year == DateTime.now().year &&
            _selectedDate.month == DateTime.now().month &&
            _selectedDate.day == DateTime.now().day
        ? "Today"
        : DateFormat('yyyy-MM-dd').format(_selectedDate);

    return BaseLayout(
      title: HOME_TITLE,
      body: Stack(
        children: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final selectedTasks = taskProvider.tasks
                  .where((task) => task.date != null)
                  .where((task) =>
                      task.date!.year == _selectedDate.year &&
                      task.date!.month == _selectedDate.month &&
                      task.date!.day == _selectedDate.day)
                  .toList();

              final currentTasks =
                  selectedTasks.where((task) => !task.isCompleted).toList();
              final completedTasks =
                  selectedTasks.where((task) => task.isCompleted).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => _changeDate(-1),
                      ),
                      Text(appBarTitle, style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () => _changeDate(1),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Current Tasks',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentTasks.length,
                      itemBuilder: (context, index) {
                        final task = currentTasks[index];
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _showTaskDetailsDialog(context, task);
                          },
                          child: TaskItem(
                            task: task,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddTaskScreen(task: task),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Completed Tasks',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _showTaskDetailsDialog(context, task);
                          },
                          child: TaskItem(
                            task: task,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddTaskScreen(task: task),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              );
            },
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final currentUser = userProvider.user;
                if (currentUser != null) {
                  return Text(
                    'Points: ${currentUser.points}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                }
                return SizedBox.shrink(); // Show nothing if user is null
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isPastDate()
          ? null
          : FloatingActionButton(
              backgroundColor: _currentTheme?.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTaskScreen(initialDate: _selectedDate),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: _currentTheme?.primaryText,
              ),
            ),
    );
  }
}
