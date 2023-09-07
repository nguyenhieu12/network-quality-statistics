import 'package:flutter/material.dart';
import 'package:network_quality_statistic/data/repositories/user_repository.dart';
import 'package:network_quality_statistic/presentation/screens/login_screen.dart';

import '../../utils/change_page.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  bool isObscure = true;
  bool reIsObscure = true;

  void handleSubmitNewPassword() async {
    if ((passwordController.text == '') || (repasswordController.text == '')) {
      alertFailed('Hãy nhập đầy đủ thông tin');
    } else if (passwordController.text != repasswordController.text) {
      alertFailed('Mật khẩu không giống nhau');
    } else {
      await UserRepository.updateUserByEmail(
          'toanquoc@gmail.com', passwordController.text);
      Navigator.push(context, ChangePage.changePage(LoginScreen()));
    }
  }

  void alertFailed(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
          child: Text(
        message,
        style: TextStyle(
            fontSize: 22,
            color: const Color.fromARGB(255, 255, 102, 102),
            fontWeight: FontWeight.w500),
      )),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 102, 102),
          centerTitle: true,
          title: Text(
            'Khôi phục mật khẩu',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 32,
                decoration: TextDecoration.none),
          ),
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        body: Container(
          color: Color.fromARGB(255, 255, 102, 102),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              SizedBox(height: screenHeight * 0.03),
              Icon(
                Icons.lock_reset_outlined,
                color: Colors.white,
                size: screenHeight * 0.15,
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.065,
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  obscureText: isObscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                      counterStyle:
                          TextStyle(color: Colors.white, fontSize: 20),
                      labelText: 'Mật khẩu',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(220, 255, 255, 255),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 26,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      )),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.065,
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  obscureText: reIsObscure,
                  controller: repasswordController,
                  decoration: InputDecoration(
                      counterStyle:
                          TextStyle(color: Colors.white, fontSize: 20),
                      labelText: 'Nhập lại mật khẩu',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(220, 255, 255, 255),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 26,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            reIsObscure = !reIsObscure;
                          });
                        },
                        icon: Icon(
                          reIsObscure ? Icons.visibility : Icons.visibility_off,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      )),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  handleSubmitNewPassword();
                },
                child: Text(
                  'Cập nhật',
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
      ),
    );
  }
}
