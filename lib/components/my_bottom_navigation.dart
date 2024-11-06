import 'package:flutter/material.dart';

class MyBottomNavigation extends StatefulWidget {
  final Function(int) onItemTap;
  const MyBottomNavigation({super.key, required this.onItemTap});

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onItemTap(index);
      },
    );
  }
}
