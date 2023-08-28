import 'package:flutter/material.dart';
import 'package:network_quality_statistic/presentation/screens/email_verification_screen.dart';
import 'package:network_quality_statistic/presentation/screens/sms_verification_screen.dart';
import 'package:network_quality_statistic/utils/change_page.dart';

class ResetOptionsScreen extends StatefulWidget {
  const ResetOptionsScreen({super.key});

  @override
  State<ResetOptionsScreen> createState() => _ResetOptionsScreenState();
}

class _ResetOptionsScreenState extends State<ResetOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 102, 102),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Text(
                      'Lấy lại mật khẩu',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Chọn phương thức lấy lại mật khẩu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: screenHeight * 0.05),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, ChangePage.changePage(SMSVerificationScreen())),
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.red,
                            size: screenHeight * 0.09,
                          ),
                        ),
                        Text(
                          'Tin nhắn qua SMS',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                          ),
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, ChangePage.changePage(EmailVerificationScreen())),
                  child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 20),
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.red,
                              size: screenHeight * 0.08,
                            ),
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                            ),
                            maxLines: 2,
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
