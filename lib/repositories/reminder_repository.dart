import 'dart:convert';

import 'package:reminders_flutter/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const reminderListKey = 'reminder_list';

class ReminderRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Reminder>> getReminderList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(reminderListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Reminder.fromJson(e)).toList();
  }

  void saveReminderList(List<Reminder> reminders) {
    final jsonString = json.encode(reminders);
    sharedPreferences.setString('reminder_list', jsonString);
  }
}