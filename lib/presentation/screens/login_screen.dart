import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_quality_statistic/logic/blocs/login/login_bloc.dart';
import 'package:network_quality_statistic/presentation/screens/landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberSelected = false;
  bool isTapped = false;
  final LoginBloc loginBloc = LoginBloc();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingScreen(
                      fullName: state.fullName, email: state.email, phoneNumber: state.phoneNumber, imageUrl: state.imageUrl)));
          debugPrint('Email: ${emailController.text}');
          debugPrint('Email: ${passwordController.text}');
        } else if (state is ShowLoginFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
                child: Text(
              'Đăng nhập thất bại, vui lòng thử lại',
              style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 255, 102, 102),
                  fontWeight: FontWeight.w500),
            )),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.white,
          ));
        }
      },
      builder: (context, state) {
        debugPrint('Current state: ${state.runtimeType}');
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              height: screenHeight,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 102, 102),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.15),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.065,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: emailController,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'toanquoc@gmail.com',
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
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.065,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          counterStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          labelText: '********',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(220, 255, 255, 255),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(children: [
                        Checkbox(
                          value: isRememberSelected,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isRememberSelected = newValue!;
                            });
                          },
                          side: MaterialStateBorderSide.resolveWith((states) =>
                              BorderSide(color: Colors.white, width: 1.0)),
                        ),
                        SizedBox(height: screenHeight * 0.08),
                        Text(
                          'Ghi nhớ đăng nhập',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.normal),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ]),
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    ElevatedButton(
                      onPressed: () {
                        loginBloc.add(LoginButtonClickedEvent(
                            email: 'toanquoc@gmail.com',
                            password: 'toanquoc'));
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Colors.white),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: screenWidth * 0.35,
                              child: Divider(
                                color: Colors.white,
                                thickness: 0.5,
                              )),
                          Text(
                            'hoặc',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Container(
                              width: screenWidth * 0.35,
                              child: Divider(
                                color: Colors.white,
                                thickness: 0.5,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.fingerprint_outlined,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.12),
                    (state is LoginLoadingState
                        ? (Platform.isAndroid
                            ? CircularProgressIndicator(color: Colors.white)
                            : CupertinoActivityIndicator(color: Colors.white))
                        : SizedBox())
                  ],
                ),
              ),
            ));
      },
    );
  }

  void alertFailed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Đăng nhập thất bại')));
  }
}
