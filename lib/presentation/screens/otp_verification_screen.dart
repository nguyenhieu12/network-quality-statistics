import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_quality_statistic/presentation/screens/reset_password_screen.dart';
import 'package:network_quality_statistic/utils/change_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  String verifyID;

  OTPVerificationScreen({required this.verifyID});

  // const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    debugPrint('OTP: ${widget.verifyID}');
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _handleBackspace() {
    for (int i = controllers.length - 1; i >= 0; i--) {
      if (controllers[i].text.isNotEmpty) {
        controllers[i].clear();
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
  }

  void _verifyOTP() async {
    try {
      final otp = controllers.map((controller) => controller.text).join();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verifyID, smsCode: otp);

    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.push(context, ChangePage.changePage(ResetPasswordScreen()));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromARGB(255, 255, 102, 102),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
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
                  'Xác thực OTP',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      decoration: TextDecoration.none),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Icon(
              Icons.phone_android,
              color: Colors.white,
              size: screenHeight * 0.15,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              'Nhập mã OTP để xác thực',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace) {
                  _handleBackspace();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.08,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: controllers[index],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index + 1]);
                          }
                        } else {
                          if (index > 0) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index - 1]);
                          }
                        }
                      },
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 40),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02)),
                      cursorColor: Colors.white,
                      focusNode: focusNodes[index], // Áp dụng FocusNode
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: Text(
                'Xác minh',
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
