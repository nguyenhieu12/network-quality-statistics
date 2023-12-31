import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:network_quality_statistic/presentation/screens/otp_verification_screen.dart';
import 'package:network_quality_statistic/utils/change_page.dart';

class SMSVerificationScreen extends StatefulWidget {
  const SMSVerificationScreen({super.key});

  @override
  State<SMSVerificationScreen> createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  TextEditingController smsController = TextEditingController();

  String codeSent = '';

  void handleSendOTP(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84${phone}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        debugPrint('OTP: ${verificationId}');
        Navigator.push(
            context,
            ChangePage.changePage(
                OTPVerificationScreen(verifyID: verificationId)));
        // codeSent = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 102, 102),
          centerTitle: true,
          title: Text(
            'Xác thực qua SMS',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 32,
                decoration: TextDecoration.none),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 36,
              ))),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromARGB(255, 255, 102, 102),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            Row(
              children: [],
            ),
            SizedBox(height: screenHeight * 0.03),
            Icon(
              Icons.sms,
              color: Colors.white,
              size: screenHeight * 0.15,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Text(
              'Nhập số điện thoại khôi phục mật khẩu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "+84",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 22),
                          isDense: true),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.06,
                    child: VerticalDivider(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: smsController,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 22.0)),
                      cursorColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                handleSendOTP(smsController.text);
              },
              child: Text(
                'Gửi mã OTP',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(), backgroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
