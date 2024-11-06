import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/helpers/database_const.dart';

import '../models/task.dart';
import '../services/notification_service.dart';

class TodoDatabase extends ChangeNotifier {
  static late Database todoDatabase;

  static Future<void> openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    // NotificationService.initialize();
    // print("abc");
    // print("Database path: $path");

    todoDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
           CREATE TABLE $tableTodo (
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnTitle TEXT NOT NULL,
                $columnDate INTEGER NOT NULL,
                $columnIsCompleted INTEGER NOT NULL,
                $columnTimeToDo INTEGER NULL,
                $columnTimeReminder INTEGER NULL
          )
        ''');
      },
    );
  }

  static Future<void> closeDB() async {
    await todoDatabase.close();
  }

  //CRUD
  List<Task> currentTasks = [];

  //Create Task
  Future<void> insertTask(Task task) async {
    int id = await todoDatabase.insert(tableTodo, task.toMap());
    await getTasks();
    // await NotificationService().scheduleNotification(task: task);
  }

  //Read all Task
  Future<void> getTasks() async {
    final List<Map<String, Object?>> taskMaps = await todoDatabase
        .query(tableTodo, orderBy: '$columnDate ASC' // Sort by date ascending
            );

    currentTasks.clear();
    //print("Current tasks: change");
    currentTasks = taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
    // print('*************************************************************');
    // Print each task's details
    // for (var task in currentTasks) {
    //     print('Task ID: ${task.id}');
    //     print('Title: ${task.title}');
    //     print('Date: ${task.date}');
    //     print('Time To Do: ${task.timeToDo}');
    //     print('Time Reminder: ${task.timeReminder}');
    //     print('Completed: ${task.isCompleted}');
    //     print('------------------------');
    // }

    notifyListeners();
  }

  //Update Task
  Future<void> updateTask(Task task) async {
    await todoDatabase.update(tableTodo, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
    await getTasks();
    // await NotificationService().scheduleNotification(task: task);
  }

  //Delete Task
  Future<void> deleteTask(int id) async {
    await todoDatabase
        .delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
    await getTasks();
    // await NotificationService().cancelNotification(id);
  }

}
