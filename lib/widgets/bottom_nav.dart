import 'package:dialpad/screen/call_history_screen.dart';
import 'package:dialpad/screen/contacts_screen.dart';
import 'package:dialpad/screen/dialpad_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CallHistoryScreen(),
    ContactsScreen(),
    DialPadScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Recents"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: "Contacts"),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: "Keypad"),
        ],
      ),
    );
  }
}
