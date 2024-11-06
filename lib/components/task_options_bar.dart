// import 'package:flutter/material.dart';
// import '../models/task.dart';

// class TaskOptionsTab extends StatefulWidget {
//   final Task task;
//   const TaskOptionsTab({super.key, required this.task});

//   @override
//   State<TaskOptionsTab> createState() => _TaskOptionsTabState();
// }

// class _TaskOptionsTabState extends State<TaskOptionsTab>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   DateTime _selectedDay = DateTime.now();
//   String dateFormat = '';
//   String timeTodoFormat = '';
//   String timeReminderFormat = '';
//   CalendarDatePicker? _calendarDatePicker;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       setState(() {});
//     });
//     dateFormat = widget.task.getFormatDate();
//     timeTodoFormat = widget.task.getFormatTimeTodo();
//     timeReminderFormat = widget.task.getFormatTimeReminder();

//     _calendarDatePicker = CalendarDatePicker(
//       initialDate: _selectedDay,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2036, 12, 31),
//       onDateChanged: (DateTime value) {
//         setState(() {
//           _selectedDay = value;
//           widget.task.date = value;
//           dateFormat = widget.task.getFormatDate();
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Widget _buildTimePickerContent(BuildContext context, bool isTimeToDo) {
//     final currentTime = isTimeToDo
//         ? widget.task.timeToDo ?? TimeOfDay.now()
//         : widget.task.timeReminder ?? TimeOfDay.now();

//     final hourController =
//         FixedExtentScrollController(initialItem: currentTime.hour);

//     final minuteController =
//         FixedExtentScrollController(initialItem: currentTime.minute);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           isTimeToDo ? 'Select Time To Do' : 'Select Reminder Time',
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Hours wheel
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 70,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 70,
//                   height: 200,
//                   child: ListWheelScrollView.useDelegate(
//                     controller: hourController,
//                     physics: const FixedExtentScrollPhysics(),
//                     diameterRatio: 1.5,
//                     itemExtent: 50,
//                     childDelegate: ListWheelChildLoopingListDelegate(
//                       children: List.generate(24, (index) {
//                         return Center(
//                           child: Text(
//                             index.toString().padLeft(2, '0'),
//                             style: const TextStyle(
//                               fontSize: 24,
//                               color: Colors.black,
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                     onSelectedItemChanged: (index) {
//                       setState(() {
//                         if (isTimeToDo) {
//                           widget.task.timeToDo = TimeOfDay(
//                               hour: index, minute: currentTime.minute);
//                           timeTodoFormat = widget.task.getFormatTimeTodo();
//                         } else {
//                           widget.task.timeReminder = TimeOfDay(
//                               hour: index, minute: currentTime.minute);

//                           timeReminderFormat =
//                               widget.task.getFormatTimeReminder();
//                         }
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const Text(':', style: TextStyle(fontSize: 24)),
//             // Minutes wheel
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 70,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 70,
//                   height: 200,
//                   child: ListWheelScrollView.useDelegate(
//                     controller: minuteController,
//                     physics: const FixedExtentScrollPhysics(),
//                     diameterRatio: 1.5,
//                     itemExtent: 50,
//                     childDelegate: ListWheelChildLoopingListDelegate(
//                       children: List.generate(60, (index) {
//                         return Center(
//                           child: Text(
//                             index.toString().padLeft(2, '0'),
//                             style: const TextStyle(
//                               fontSize: 24,
//                               color: Colors.black,
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                     onSelectedItemChanged: (index) {
//                       setState(() {
//                         if (isTimeToDo) {
//                           widget.task.timeToDo =
//                               TimeOfDay(hour: currentTime.hour, minute: index);
//                           timeTodoFormat = widget.task.getFormatTimeTodo();
//                         } else {
//                           widget.task.timeReminder =
//                               TimeOfDay(hour: currentTime.hour, minute: index);
//                           timeReminderFormat =
//                               widget.task.getFormatTimeReminder();
//                         }
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               if (isTimeToDo) {
//                 widget.task.timeToDo = null;
//                 timeTodoFormat = widget.task.getFormatTimeTodo();
//               } else {
//                 widget.task.timeReminder = null;
//                 timeReminderFormat = widget.task.getFormatTimeReminder();
//               }
//             });
//           },
//           child: const Text('Reset'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 dateFormat,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 timeTodoFormat,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 timeReminderFormat,
//                 style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red),
//               ),
//             )
//           ],
//         ),
//         TabBar(
//           controller: _tabController,
//           onTap: (index) => FocusScope.of(context).unfocus(),
//           tabs: const [
//             Tab(
//               icon: Icon(Icons.calendar_today, size: 15),
//               text: 'Calendar',
//               height: 40,
//             ),
//             Tab(
//               icon: Icon(Icons.timer, size: 15),
//               text: 'Timer',
//               height: 40,
//             ),
//             Tab(
//               icon: Icon(Icons.notifications, size: 15),
//               text: 'Reminder',
//               height: 40,
//             ),
//           ],
//         ),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               // Calendar Tab Content
//               Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: ColorScheme.light(
//                     primary: Colors.amber[600]!,
//                     onPrimary: Colors.white,
//                     surface: const Color.fromARGB(255, 129, 138, 207),
//                     onSurface: Colors.black,
//                   ),
//                 ),
//                 child: _calendarDatePicker!,
//               ),
//               // Timer Tab Content
//               _buildTimePickerContent(context, true),

//               _buildTimePickerContent(context, false),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskOptionsTab extends StatefulWidget {
  final Task task;
  void Function() onUpdateInforTask;
  TaskOptionsTab(
      {super.key, required this.task, required this.onUpdateInforTask});

  @override
  State<TaskOptionsTab> createState() => _TaskOptionsTabState();
}

class _TaskOptionsTabState extends State<TaskOptionsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDay;
  CalendarDatePicker? _calendarDatePicker;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _selectedDay = widget.task.date;
      print("Okla----------------------------> ${_selectedDay.toString()}");
    });

    _calendarDatePicker = CalendarDatePicker(
      initialDate: _selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime(2036, 12, 31),
      onDateChanged: (DateTime value) {
        setState(() {
          _selectedDay = value;
          widget.task.date =
              value; // task in task_options_bar.dart and task in content_in_bottomsheet.dart are the same object
          widget.onUpdateInforTask();
        });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTimePickerContent(BuildContext context, bool isTimeToDo) {
    final currentTime = isTimeToDo
        ? widget.task.timeToDo ?? TimeOfDay.now()
        : widget.task.timeReminder ?? const TimeOfDay(hour: 0, minute: 0);

    final hourController =
        FixedExtentScrollController(initialItem: currentTime.hour);

    final minuteController =
        FixedExtentScrollController(initialItem: currentTime.minute);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isTimeToDo ? 'Select Time To Do' : 'Reminder before: ',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hours wheel
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 200,
                  child: ListWheelScrollView.useDelegate(
                    controller: hourController,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    itemExtent: 50,
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(24, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (isTimeToDo) {
                          widget.task.timeToDo = TimeOfDay(
                              hour: index, minute: currentTime.minute);
                          widget.onUpdateInforTask();
                        } else {
                          widget.task.timeReminder = TimeOfDay(
                              hour: index, minute: currentTime.minute);
                          widget.onUpdateInforTask();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const Text(':', style: TextStyle(fontSize: 24)),
            // Minutes wheel
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 200,
                  child: ListWheelScrollView.useDelegate(
                    controller: minuteController,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 1.5,
                    itemExtent: 50,
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(60, (index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (isTimeToDo) {
                          widget.task.timeToDo =
                              TimeOfDay(hour: currentTime.hour, minute: index);
                          widget.onUpdateInforTask();
                        } else {
                          widget.task.timeReminder =
                              TimeOfDay(hour: currentTime.hour, minute: index);
                          widget.onUpdateInforTask();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        //Reset button
        ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[300],
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (isTimeToDo) {
                widget.task.timeToDo = null;
                widget.onUpdateInforTask();
              } else {
                widget.task.timeReminder = null;
                widget.onUpdateInforTask();
              }
            });
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: (index) => FocusScope.of(context).unfocus(),
          tabs: const [
            Tab(
              text: 'Calendar',
              height: 40,
            ),
            Tab(
              text: 'Timer',
              height: 40,
            ),
            Tab(
              text: 'Reminder',
              height: 40,
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Calendar Tab Content
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                ),
                child: _calendarDatePicker!,
              ),
              // Timer Tab Content
              _buildTimePickerContent(context, true),

              _buildTimePickerContent(context, false),
            ],
          ),
        ),
      ],
    );
  }
}
