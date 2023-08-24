import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_quality_statistic/presentation/screens/dashboard_screen.dart';
import 'package:network_quality_statistic/presentation/screens/line_screen.dart';
import 'package:network_quality_statistic/presentation/screens/setting_screen.dart';

import '../../logic/blocs/landing/landing_bloc.dart';

class LandingScreen extends StatefulWidget {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;

  LandingScreen(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final LandingBloc landingBloc = LandingBloc();

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_road),
      label: 'Đường',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt')
  ];

  BottomNavigationBar buildBottomNavigationBar(int currentIndex) {
    return BottomNavigationBar(
      selectedItemColor: Color.fromARGB(255, 255, 102, 102),
      backgroundColor: Colors.white,
      items: bottomNavItems,
      currentIndex: currentIndex,
      onTap: (index) {
        landingBloc.add(TabChangeEvent(tabIndex: index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screenList = [
      DashboardScreen(),
      LineScreen(),
      SettingScreen(
          id: widget.id,
          fullName: widget.fullName,
          email: widget.email,
          phoneNumber: widget.phoneNumber,
          imageUrl: widget.imageUrl)
    ];

    return BlocConsumer<LandingBloc, LandingState>(
      bloc: landingBloc,
      listenWhen: (previous, current) => current is LandingActionState,
      buildWhen: (previous, current) => current is! LandingActionState,
      listener: (context, state) {},
      builder: (context, state) {
        int currentIndex = 0;

        if (state is LineTabSelectedState) {
          currentIndex = 1;
        } else if (state is SettingTabSelectedState) {
          currentIndex = 2;
        }

        return Container(
          decoration: currentIndex == 0
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                )
              : null,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: screenList[currentIndex],
            bottomNavigationBar: buildBottomNavigationBar(currentIndex),
          ),
        );
      },
    );
  }
}
