import 'package:flutter/material.dart';
import '../models/task.dart';
import 'todo_item.dart';

class GroupTodoItem extends StatelessWidget {
  final String date;
  final List<Task> tasks;

  const GroupTodoItem({
    super.key,
    required this.date,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...tasks.map((task) => TodoItem(task: task)).toList(),
        Divider(),
      ],
    );
  }
}
