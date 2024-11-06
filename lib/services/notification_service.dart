import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../database/todo_database.dart';
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification tapped: ${details.payload}");
      },
    );
  }

  Future<bool> checkPermissionStatus() async {
    final status = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    return status ?? false;
  }

  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> openNotificationSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.notification,
    );
  }

  Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!;
      return await androidImplementation.requestExactAlarmsPermission() ??
          false;
    }
    return true;
  }

  //Add notification
  Future<void> scheduleNotification({
    required Task task,
  }) async {
    try {
      final bool hasPermission = await checkPermissionStatus();
      if (!hasPermission) {
        print('Notification permission not granted');
        return;
      }

      final bool hasExactAlarmPermission = await requestExactAlarmPermission();
      if (!hasExactAlarmPermission) {
        print('Exact alarm permission not granted');
        return;
      }
      if (task.timeToDo == null || task.timeReminder == null) {
        return;
      }
      // Create DateTime for the task's time to do
      final DateTime taskDateTime = DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
        task.timeToDo?.hour ?? 0,
        task.timeToDo?.minute ?? 0,
      );

      // Calculate when to send notification by subtracting reminder time from task time
      final int reminderMinutes = (task.timeReminder?.hour ?? 0) * 60 +
          (task.timeReminder?.minute ?? 0);
      final DateTime notificationTime =
          taskDateTime.subtract(Duration(minutes: reminderMinutes));

      final tz.TZDateTime scheduledDate =
          tz.TZDateTime.from(notificationTime, tz.local);

      if (scheduledDate.isBefore(DateTime.now())) {
        print('Scheduled time must be in the future');
        return;
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        'Task starts in ${reminderMinutes} minutes',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_channel_id',
            'My Channel',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  // Delete notification by ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Delete all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  //set notification for all tasks
  Future<void> setNotificationForAll(var currentTasks) async {
    List<Task> items = List.from(currentTasks);
    for (var task in items) {
      if (task.timeToDo != null && task.timeReminder != null) {
        await NotificationService().scheduleNotification(task: task);
      }
    }
    
  }
}
