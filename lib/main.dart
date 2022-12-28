import 'package:flutter/material.dart';
import 'package:reminders_flutter/routes/reminder_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReminderListPage(),
    );
  }
}