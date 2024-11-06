import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/content_in_bottomsheet.dart';

import '../database/todo_database.dart';
import '../models/task.dart';

class TodoItem extends StatefulWidget {
  final Task task;
  const TodoItem({super.key, required this.task});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('Build o todo Item');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.yellow,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                // print('Bam vao nut chinh sua');
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                  Provider.of<TodoDatabase>(context, listen: false)
                      .updateTask(widget.task);
                });
              },
              icon: Icon(
                widget.task.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              )),
          const SizedBox(width: 5),
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    // print(
                    //     'Build o bottom sheet trong todo item ${widget.task.hashCode}');
                    return ContentInBottomSheet(myTask: widget.task);
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: widget.task.isCompleted
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough)
                        : null,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  Text(widget.task.timeToDoString,
                      style: const TextStyle(fontSize: 12, color: Colors.red)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text(
                        'Are you sure to delete ${widget.task.title}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Provider.of<TodoDatabase>(context, listen: false)
                              .deleteTask(widget.task.id!);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
            padding: const EdgeInsets.all(5),
          )
        ],
      ),
    );
  }
}
