import 'package:flutter/material.dart';
import 'package:todo_app/helpers/database_const.dart';

class Task {
  int? id;
  String title;
  DateTime date;
  bool isCompleted;
  TimeOfDay? timeToDo;
  TimeOfDay? timeReminder;// task will start at timeTodo in timeReminder

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.isCompleted,
    this.timeToDo,
    this.timeReminder,
  });
  get timeToDoString => timeToDo != null
      ? '${timeToDo!.hour.toString().padLeft(2, '0')}:${timeToDo!.minute.toString().padLeft(2, '0')}'
      : '';
  //Format to display in bottom sheet
  String getFormattedDateTime() {
    String dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    String timeStr = timeToDo != null
        ? ', At ${timeToDo!.hour.toString().padLeft(2, '0')}:${timeToDo!.minute.toString().padLeft(2, '0')}'
        : '';

    String reminderStr = timeReminder != null
        ? ', Reminder before: ${timeReminder!.hour.toString().padLeft(2, '0')}:${timeReminder!.minute.toString().padLeft(2, '0')}'
        : '';

    return 'Date: $dateStr$timeStr$reminderStr';
  }
  String getFormatDate(){
    return 'Date: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  String getFormatTimeTodo(){
    return timeToDo != null
        ? 'Time todo: ${timeToDo!.hour.toString().padLeft(2, '0')}:${timeToDo!.minute.toString().padLeft(2, '0')}'
        : 'Time todo:';
  }
  String getFormatTimeReminder(){
    return timeReminder != null
        ? 'Reminder before: ${timeReminder!.hour.toString().padLeft(2, '0')}:${timeReminder!.minute.toString().padLeft(2, '0')}'
        : 'Reminder before:';
  }

  // Convert TimeOfDay to minutes - make it static
  static int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Convert minutes to TimeOfDay - make it static
  static TimeOfDay minutesToTime(int minutes) {
    return TimeOfDay(
      hour: minutes ~/ 60,
      minute: minutes % 60,
    );
  }

  Map<String, Object?> toMap() {
    final dateOnly = DateTime(date.year, date.month, date.day);

    var map = <String, Object?>{
      columnTitle: title,
      columnDate: dateOnly.millisecondsSinceEpoch,
      columnIsCompleted: isCompleted ? 1 : 0,
      columnTimeToDo: timeToDo != null ? Task.timeToMinutes(timeToDo!) : null,
      columnTimeReminder:
          timeReminder != null ? Task.timeToMinutes(timeReminder!) : null,
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map[columnId] as int?,
      title: map[columnTitle] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map[columnDate] as int),
      isCompleted: map[columnIsCompleted] == 1,
      timeToDo: map[columnTimeToDo] != null
          ? Task.minutesToTime(map[columnTimeToDo] as int)
          : null,
      timeReminder: map[columnTimeReminder] != null
          ? Task.minutesToTime(map[columnTimeReminder] as int)
          : null,
    );
  }
}
