import 'package:flutter/material.dart';
import 'package:reminders_flutter/models/reminder.dart';

class ReminderTextPage extends StatefulWidget {
  ReminderTextPage({super.key, required this.reminder});
  final Reminder reminder;

  @override
  State<ReminderTextPage> createState() => _ReminderTextPageState();
}

class _ReminderTextPageState extends State<ReminderTextPage> {
  final TextEditingController reminderEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      reminderEditController.text = widget.reminder.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff000000),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.reminder.title = reminderEditController.text;
                          widget.reminder.dateTime = DateTime.now();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff17181c),
                            fixedSize: Size.square(50)),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 26,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Expanded(
                    child: TextField(
                      controller: reminderEditController,
                      minLines: 1,
                      maxLines: 35,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xff17181c),
                      ),
                      cursorColor: Color(0xffffffff),
                      style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
