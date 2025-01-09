import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/screens/add_task_screen.dart';
import 'package:prioritize_it/screens/task_detail_screen.dart';
import 'package:prioritize_it/widgets/task_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const HomeScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId =
        Provider.of<CustomAuthProvider>(context, listen: false).currentUser?.id;
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _loadTasksForSelectedDate();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && widget.selectedDate != _selectedDate) {
      _selectedDate = widget.selectedDate!;
      _loadTasksForSelectedDate();
    }
  }

  void _loadTasksForSelectedDate() {
    Provider.of<TaskProvider>(context, listen: false)
        .loadTasksForDate(_currentUserId!, _selectedDate);
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _loadTasksForSelectedDate();
    });
  }

  bool _isPastDate() {
    final now = DateTime.now();
    return _selectedDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (_selectedDate.year == DateTime.now().year &&
        _selectedDate.day == DateTime.now().day &&
        _selectedDate.month == DateTime.now().month) {
      appBarTitle = "Today";
    } else {
      appBarTitle = DateFormat('yyyy-MM-dd').format(_selectedDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Prioritize It', style: TextStyle(fontSize: 15)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => _changeDate(-1),
                        ),
                        Text(appBarTitle, style: TextStyle(fontSize: 20)),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () => _changeDate(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 40),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Prioritize-It',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Themes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/themes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Streaks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/streak');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final authProvider =
                Provider.of<CustomAuthProvider>(context, listen: false);
                await authProvider.logOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Current Tasks',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: currentTasks.length,
                  itemBuilder: (context, index) {
                    final task = currentTasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      child: TaskItem(
                        task: task,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Completed Tasks',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      child: TaskItem(
                        task: task,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _isPastDate()
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTaskScreen(initialDate: _selectedDate),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}