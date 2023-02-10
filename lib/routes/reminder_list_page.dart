import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:reminders_flutter/models/reminder.dart';
import 'package:reminders_flutter/repositories/reminder_repository.dart';
import 'package:reminders_flutter/routes/reminder_text_page.dart';

class ReminderListPage extends StatefulWidget {
  ReminderListPage({super.key});

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  final TextEditingController reminderController = TextEditingController();
  final ReminderRepository reminderRepository = ReminderRepository();

  List<Reminder> reminders = [];
  Reminder? deletedReminder;
  int? deletedReminderPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    reminderRepository.getReminderList().then((value) {
      setState(() {
        reminders = value;
        reminders.sort((b, a) {
          return DateTime.parse((b.dateTime).toIso8601String())
              .compareTo(DateTime.parse((a.dateTime).toIso8601String()));
        });
      });
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        controller: reminderController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
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
                          fillColor: Color(0xffffffff).withOpacity(0.3),
                          labelText: null,
                          hintText: 'Adicione um lembrete',
                          hintStyle: TextStyle(
                            color: Color(0xffffffff).withOpacity(0.5),
                          ),
                          errorText: errorText,
                        ),
                        cursorColor: Color(0xffffffff).withOpacity(0.5),
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffffffff)),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          String text = reminderController.text;
                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'Campo obrigatório';
                            });
                          } else {
                            setState(() {
                              Reminder newReminder = Reminder(
                                  title: text, dateTime: DateTime.now());
                              reminders.add(newReminder);
                              errorText = null;
                            });
                            reminderController.clear();
                            reminderRepository.saveReminderList(reminders);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff3a3a3a),
                            fixedSize: Size.square(50)),
                        child: Icon(
                          Icons.add,
                          size: 26,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Reminder reminder in reminders.reversed)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              extentRatio: 0.2,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    onDelete(reminder);
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReminderTextPage(reminder: reminder),
                                  ),
                                ).then((_) => setState(() {
                                      reminders.sort((b, a) {
                                        return DateTime.parse(
                                                (b.dateTime).toIso8601String())
                                            .compareTo(DateTime.parse(
                                                (a.dateTime).toIso8601String()));
                                      });
                                    }));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff3a3a3a),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy - HH:mm')
                                          .format(reminder.dateTime),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      reminder.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteAllConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3a3a3a),
                        padding: const EdgeInsets.all(18),
                      ),
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Reminder reminder) {
    deletedReminder = reminder;
    deletedReminderPos = reminders.indexOf(reminder);

    setState(() {
      reminders.remove(reminder);
      errorText = null;
    });

    reminderRepository.saveReminderList(reminders);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Lembrete removido com sucesso',
          style: TextStyle(
            color: Color(0xffffffff).withOpacity(0.9),
            fontSize: 16,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xff3a3a3a),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.yellow,
          onPressed: () {
            setState(() {
              reminders.insert(deletedReminderPos!, deletedReminder!);
            });
            reminderRepository.saveReminderList(reminders);
          },
        ),
      ),
    );
  }

  void showDeleteAllConfirmationDialog() {
    if (reminders.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: AlertDialog(
            backgroundColor: Color(0xff3a3a3a),
            title: Text(
              'Deletar permanentemente todos os lembretes?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  errorText = null;
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteAll();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: Text(
                  'Limpar tudo',
                  style: TextStyle(),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Você não possui lembretes',
            style: TextStyle(
              color: Color(0xffffffff).withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xff3a3a3a),
        ),
      );
    }
  }

  void deleteAll() {
    setState(() {
      reminders.clear();
      errorText = null;
    });
    reminderRepository.saveReminderList(reminders);
  }
}
