import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/todo_database.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  bool isNotifications = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService.initialize();
    _checkNotificationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationStatus();
    }
  }

  Future<void> _checkNotificationStatus() async {
    final status = await _notificationService.checkPermissionStatus();
    setState(() {
      isNotifications = status;
    });

    //If user go to setting_page and change to enable notification, and exit app
    //we need setNotification again
    if (isNotifications) {
      // print("abcok la ---------------->");
      var currentTasks =
          Provider.of<TodoDatabase>(context, listen: false).currentTasks;
      //Cancel all notification
      NotificationService().cancelAllNotifications();
      //Schedule all notification for if user set before, but turn off notification, it will delete and set from start.
      NotificationService().setNotificationForAll(currentTasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Notification Status: ${isNotifications ? 'ON' : 'OFF'}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              
              onPressed: () =>
                  _notificationService.openNotificationSettings(),
              icon: const Icon(Icons.settings),
              label: const Text("Open Notification Settings",),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            // const SizedBox(height: 12),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     for (int i = 1; i <= 5; i++) {
            //       try {
            //         final scheduledTime =
            //             DateTime.now().add(Duration(seconds: i*2));
            //         await _notificationService.scheduleNotification(
            //           scheduledTime: scheduledTime,
            //           title: 'Test Notification ${i}',
            //           description: 'This is a test notification',
            //         );
            //       } catch (e) {
            //         if (mounted) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //                 content: Text(
            //                     'Failed to schedule notification: $e')),
            //           );
            //         }
            //       }
            //     }
            //   },
            //   icon: const Icon(Icons.notification_add),
            //   label: const Text("Test Notification"),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 48),
            //   ),
            // ),
          ],
        ),
    );
  }
}