import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/group_todo_item.dart';
import '../components/my_search_bar.dart';
import '../database/todo_database.dart';
import '../models/task.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? searchingText = "";

  //All Tasks
  List<Task> currentTasks = [];

  //Filter Task by seachingText
  List<Task> filteredTasks = [];

  // {"Date1" : [Task1, Task2, Task3], "Date2" : [Task4, Task5, Task6]}
  Map<String, List<Task>> displayTasks = {};

  @override
  void initState() {
    super.initState();
    Provider.of<TodoDatabase>(context, listen: false).getTasks();
  }

  void onTextChangedInSearchBar(String? searchingTextFrommSearchBar) {
    {
      setState(() {
        searchingText = searchingTextFrommSearchBar;
      });
    }
  }

//Filter seachingText
  void getFilteredTasks(String? seachingText) {
    if (seachingText == null || seachingText.isEmpty) {
      filteredTasks = [];
      return;
    }
    //  print('seachingText: $seachingText');
    filteredTasks = currentTasks.where((task) {
      return task.title.toLowerCase().contains(seachingText.toLowerCase());
    }).toList();
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
    currentTasks =
        Provider.of<TodoDatabase>(context, listen: true).currentTasks;
    getFilteredTasks(searchingText);
    getDisplayTasks();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Column(
        children: [
          MySearchBar(
            onTextChanged: onTextChangedInSearchBar,
          ),
          (displayTasks.isEmpty)
              ? Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/searching.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No tasks found',
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
              : Expanded(
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
                ),
        ],
      ),
    );
  }
}
