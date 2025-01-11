//calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:prioritize_it/screens/home_screen.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    return BaseLayout(
        title: CALENDAR_TITLE,
        body: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          calendarStyle: CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: theme.primary, shape: BoxShape.circle)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(selectedDate: _selectedDay),
                ),
              );
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ));
  }
}
