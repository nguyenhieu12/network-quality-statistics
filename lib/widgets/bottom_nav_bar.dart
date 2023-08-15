import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: 'Dashboard'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_road),
      label: 'Đường',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Cài đặt'
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: bottomNavItems);
  }
}