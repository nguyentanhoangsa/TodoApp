// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../database/todo_database.dart';
// import '../models/task.dart';
// import '../services/notification_service.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
//   bool isNotifications = false;
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     NotificationService.initialize();
//     _checkNotificationStatus();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _checkNotificationStatus();
//     }
//   }

//   Future<void> _checkNotificationStatus() async {
//     final status = await _notificationService.checkPermissionStatus();
//     setState(() {
//       isNotifications = status;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Notification Status: ${isNotifications ? 'ON' : 'OFF'}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton.icon(
//                       onPressed: () =>
//                           _notificationService.openNotificationSettings(),
//                       icon: const Icon(Icons.settings),
//                       label: const Text("Open Notification Settings"),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 48),
//                       ),
//                     ),
//                     // const SizedBox(height: 12),
//                     // ElevatedButton.icon(
//                     //   onPressed: () async {
//                     //     for (int i = 1; i <= 5; i++) {
//                     //       try {
//                     //         final scheduledTime =
//                     //             DateTime.now().add(Duration(seconds: i*2));
//                     //         await _notificationService.scheduleNotification(
//                     //           scheduledTime: scheduledTime,
//                     //           title: 'Test Notification ${i}',
//                     //           description: 'This is a test notification',
//                     //         );
//                     //       } catch (e) {
//                     //         if (mounted) {
//                     //           ScaffoldMessenger.of(context).showSnackBar(
//                     //             SnackBar(
//                     //                 content: Text(
//                     //                     'Failed to schedule notification: $e')),
//                     //           );
//                     //         }
//                     //       }
//                     //     }
//                     //   },
//                     //   icon: const Icon(Icons.notification_add),
//                     //   label: const Text("Test Notification"),
//                     //   style: ElevatedButton.styleFrom(
//                     //     minimumSize: const Size(double.infinity, 48),
//                     //   ),
//                     // ),
                  
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                      label: const Text("Open Notification Settings"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
