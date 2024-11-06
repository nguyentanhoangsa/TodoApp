import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/task_options_bar.dart';
import '../database/todo_database.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class ContentInBottomSheet extends StatefulWidget {
  final Task myTask;

  const ContentInBottomSheet({super.key, required this.myTask});

  @override
  State<ContentInBottomSheet> createState() => _ContentInBottomSheetState();
}

class _ContentInBottomSheetState extends State<ContentInBottomSheet> {
  final TextEditingController _textEditingTaskController =
      TextEditingController();
  String dateFormat = '';
  String timeTodoFormat = '';
  String timeReminderFormat = '';

  @override
  void initState() {
    super.initState();
    // print('haskcode intit: ${widget.myTask.hashCode}');
    if (widget.myTask.id != null) {
      _textEditingTaskController.text = widget.myTask.title;
    }
    dateFormat = widget.myTask.getFormatDate();
    timeTodoFormat = widget.myTask.getFormatTimeTodo();
    timeReminderFormat = widget.myTask.getFormatTimeReminder();
  }

  @override
  void dispose() {
    _textEditingTaskController.dispose();
    super.dispose();
  }

  //Call from task_options_bar.dart
  void updateTaskInfor() {
    setState(() {
      dateFormat = widget.myTask.getFormatDate();
      timeTodoFormat = widget.myTask.getFormatTimeTodo();
      timeReminderFormat = widget.myTask.getFormatTimeReminder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: _textEditingTaskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your task here',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal)),
              ),
              IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    //if the task.id is null,

                    if (_textEditingTaskController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter your task",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }

                    if (widget.myTask.timeToDo == null &&
                        widget.myTask.timeReminder != null) {
                      Fluttertoast.showToast(
                        msg: "Enter your time to do or delete time reminder",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }

                    if (widget.myTask.timeToDo != null &&
                        widget.myTask.timeReminder != null) {
                      // Create DateTime for task's time to do
                      final taskDateTime = DateTime(
                        widget.myTask.date.year,
                        widget.myTask.date.month,
                        widget.myTask.date.day,
                        widget.myTask.timeToDo!.hour,
                        widget.myTask.timeToDo!.minute,
                      );

                      // Calculate reminder minutes
                      final reminderMinutes =
                          widget.myTask.timeReminder!.hour * 60 +
                              widget.myTask.timeReminder!.minute;

                      // Calculate notification time
                      final notificationTime = taskDateTime
                          .subtract(Duration(minutes: reminderMinutes));

                      if (notificationTime.isBefore(DateTime.now())) {
                        Fluttertoast.showToast(
                          msg:
                              "Reminder time is in the past. Please set a future time.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }
                    }

                    if (widget.myTask.id == null) {
                      print(
                          'Widge Luc an nut id null: ${widget.myTask.hashCode}');
                      widget.myTask.title = _textEditingTaskController.text;
                      Provider.of<TodoDatabase>(context, listen: false)
                          .insertTask(widget.myTask);
                      _textEditingTaskController.clear();
                      //Reset task for next task without close bottomsheet
                      widget.myTask.title = '';
                      widget.myTask.timeToDo = null;
                      widget.myTask.timeReminder = null;
                      widget.myTask.date = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      );
                      widget.myTask.isCompleted = false;
                      updateTaskInfor();
                      // print(
                      //     'Widge Luc an nut id null lan 2: ${widget.myTask.hashCode}');
                    } else {
                      print(
                          'Widge Luc an nut co id: ${widget.myTask.hashCode} vs id la ${widget.myTask.id}');
                      //if the task.id is not null, update the task
                      widget.myTask.title = _textEditingTaskController.text;
                      Provider.of<TodoDatabase>(context, listen: false)
                          .updateTask(widget.myTask);

                      Navigator.pop(context);
                    }

                    _textEditingTaskController.clear();
                  },
                  icon: const Icon(
                    Icons.arrow_circle_up_rounded,
                    size: 30,
                  ))
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  dateFormat,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Expanded(
                child: Text(
                  timeTodoFormat,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Expanded(
                child: Text(
                  timeReminderFormat,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            ],
          ),
          SizedBox(height: 6),
          Expanded(child: TaskOptionsTab(task: widget.myTask,onUpdateInforTask: updateTaskInfor,)),
        ],
      ),
    );
  }
}
