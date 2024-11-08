import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/my_search_bar.dart';
import 'package:todo_app/components/todo_item.dart';
import 'package:todo_app/database/todo_database.dart';

import '../components/group_todo_item.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedValue = 0;
  //All Tasks
  List<Task> currentTasks = [];

  //Filter Task by All, Today, Upcoming
  List<Task> filteredTasks = [];

  // {"Date1" : [Task1, Task2, Task3], "Date2" : [Task4, Task5, Task6]}
  Map<String, List<Task>> displayTasks = {};


  @override
  void initState() {
    super.initState();
    //_initializeNotifications();
    Provider.of<TodoDatabase>(context, listen: false).getTasks();
  }


//Filter Task by All, Today, Upcoming
  void getFilteredTasks() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (selectedValue == 0) {
      filteredTasks = currentTasks;
    } else if (selectedValue == 1) {
      filteredTasks = currentTasks.where((task) {
        DateTime taskDate =
            DateTime(task.date.year, task.date.month, task.date.day);
        return taskDate.isAtSameMomentAs(today);
      }).toList();
    } else if (selectedValue == 2) {
      filteredTasks = currentTasks.where((task) {
        DateTime taskDate =
            DateTime(task.date.year, task.date.month, task.date.day);
        return taskDate.isAfter(today);
      }).toList();
    }
  }

//Get Task by group by date
  void getDisplayTasks() {
    displayTasks.clear();

    int i = 0;
    while (i < filteredTasks.length) {
      String dateKey =
          "${filteredTasks[i].date.day}/${filteredTasks[i].date.month}/${filteredTasks[i].date.year}";
      List<Task> tasksForDate = [];

      // Collect all tasks with the same date
      while (i < filteredTasks.length) {
        Task currentTask = filteredTasks[i];
        String currentDateKey =
            "${currentTask.date.day}/${currentTask.date.month}/${currentTask.date.year}";

        if (currentDateKey != dateKey) break;

        tasksForDate.add(currentTask);
        i++;
      }
      String nowDateKey =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      if (dateKey == nowDateKey) {
        dateKey = 'Today';
      }
      displayTasks[dateKey] = tasksForDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Build in HomePage");
    currentTasks =
        Provider.of<TodoDatabase>(context, listen: true).currentTasks;
    getFilteredTasks();
    getDisplayTasks();
    //Cancel all notification
    // NotificationService().cancelAllNotifications();
    //Schedule all notification for if user set before, but turn off notification, it will delete and set from start.
    NotificationService().setNotificationForAll(currentTasks);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as int;
                          });
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedValue = 0;
                            });
                          },
                          child: const Text('All')),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as int;
                          });
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedValue = 1;
                            });
                          },
                          child: const Text('Today')),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Row(children: [
                    Radio(
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as int;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedValue = 2;
                          });
                        },
                        child: const Text('Upcoming')),
                  ]))
            ],
          ),
          displayTasks.isEmpty
              ? Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Image.asset(
                          'lib/assets/no_task.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'You have no tasks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : //if else
              //ListTask
              Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: displayTasks.length,
                    itemBuilder: (context, index) {
                      String date = displayTasks.keys.elementAt(index);
                      List<Task> tasks = displayTasks[date]!;
                      return GroupTodoItem(
                        date: date,
                        tasks: tasks,
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
