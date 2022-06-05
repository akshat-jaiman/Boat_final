import 'package:boat/ui/chatpage.dart';
import 'package:boat/ui/homepage.dart';
import 'package:boat/ui/mappage.dart';
import 'package:boat/ui/searchchat.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    SearchChat(),
    ChatPage(),
    MapPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "CHAT",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "GROUP CHAT",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.room),
              label: "MAP",
            ),
          ]),
    );
  }
}
