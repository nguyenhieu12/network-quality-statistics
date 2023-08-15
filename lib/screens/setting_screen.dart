import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_quality_statistic/screens/account_info_screen.dart';
import 'package:network_quality_statistic/screens/update_account_screen.dart';

import '../blocs/setting/setting_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isTurnOn = false;
  final SettingBloc settingBloc = SettingBloc();

  PageRouteBuilder changePage(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        // const duration = Duration(milliseconds: 500);

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return SlideTransition(
              position: tween.animate(animation),
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<SettingBloc, SettingState>(
      bloc: settingBloc,
      listenWhen: (previous, current) => current is SettingActionState,
      buildWhen: (previous, current) => current is !SettingActionState,
      listener: (context, state) {
        switch(state.runtimeType) {
          case NavigateToAccountInfoState:
            Navigator.push(context, changePage(AccountInfoScreen()));
          case NavigateToUpdateAccountState:
            Navigator.push(context, changePage(UpdateAccountScreen()));
          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1, top: screenHeight * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cài đặt',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tài khoản',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    child: Container(
                      height: screenHeight * 0.15,
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          settingBloc.add(AccountInfoClickedEvent());
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 55.0,
                              backgroundImage: NetworkImage(
                                  'https://mirror-media.imgix.net/publication-images/_Cw2xE5CuyrQvxgsrisDb.png?h=800&w=1200'),
                              backgroundColor: Colors.transparent,
                            ),
                            Text(
                              'Nguyễn Văn A',
                              style: TextStyle(fontSize: 22),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: screenWidth * 0.05),
                              child: Icon(Icons.chevron_right_rounded, size: 28),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Divider(),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Tùy chọn',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Row(children: [
                        Icon(
                          Icons.notifications_active,
                          color: Color.fromARGB(255, 255, 128, 0),
                          size: 30,
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        Text(
                          'Thông báo',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        )
                      ]),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.05),
                        child: Platform.isAndroid
                            ? Switch(
                                trackOutlineColor:
                                    MaterialStateColor.resolveWith(
                                        (states) => Colors.transparent),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                activeColor: Colors.white,
                                activeTrackColor: Color.fromARGB(255, 16, 210, 22),
                                value: (state is SwitchOnState ? true : false),
                                onChanged: (newValue) {
                                  settingBloc.add(NotificationSwitchClickedEvent());
                                }
                              )
                            : CupertinoSwitch(
                                trackColor: Color.fromARGB(255, 16, 210, 22),
                                activeColor: Colors.white,
                                value: (state is SwitchOnState ? true : false),
                                onChanged: (newValue) {
                                  settingBloc.add(NotificationSwitchClickedEvent());
                                }
                              ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.12),
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Divider(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  GestureDetector(
                    onTap: () {
                      settingBloc.add(UpdateAccountClickedEvent());
                    },
                    child: Row(
                      children: [
                        Row(children: [
                          Icon(
                            Icons.update,
                            color: Color.fromARGB(255, 26, 198, 32),
                            size: 30,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Cập nhật tài khoản',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )
                        ]),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.05),
                          child: Icon(Icons.keyboard_arrow_right, size: 24),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.12),
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Divider(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Row(
                      children: [
                        Row(children: [
                          Icon(
                            Icons.logout_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          )
                        ]),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.05),
                          child: Icon(Icons.keyboard_arrow_right, size: 24),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.12),
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Divider(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}