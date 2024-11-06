import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/my_bottom_navigation.dart';
import 'package:todo_app/pages/search_page.dart';

import 'components/content_in_bottomsheet.dart';
import 'database/todo_database.dart';
import 'models/task.dart';
import 'pages/home_page.dart';
import 'pages/setting_page.dart';
import 'services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoDatabase.openDB();
  tz.initializeTimeZones();
  // await TodoDatabase.deleteTasksBeforeToday();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoDatabase()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  final List<Widget> pages = [HomePage(), SearchPage(), SettingPage()];
  final List<String> pageNames = ['Home', 'Search', 'Settings'];

  @override
  void dispose() {
    TodoDatabase.closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var newTask = Task(
      id: null,
      title: "",
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      isCompleted: false,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(pageNames[currentIndex]),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.orange,
        ),
        body: pages[currentIndex],
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                print(
                    '-----------------Ok main build lai trong bottomsheet----');
                print('newTask co hashcode la: ${newTask.hashCode}');
                return ContentInBottomSheet(myTask: newTask);
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: MyBottomNavigation(
          onItemTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
