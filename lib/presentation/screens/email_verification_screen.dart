import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController emailController = TextEditingController();

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
                  'Xác thực qua Email',
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
              Icons.mark_email_read_outlined,
              color: Colors.white,
              size: screenHeight * 0.15,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              'Nhập email khôi phục mật khẩu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.07,
              child: TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 22),
                controller: emailController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(220, 255, 255, 255),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 26,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0)),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
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
