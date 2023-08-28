import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_quality_statistic/logic/blocs/login/login_bloc.dart';
import 'package:network_quality_statistic/presentation/screens/landing_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:network_quality_statistic/presentation/screens/reset_options_screen.dart';
import 'package:network_quality_statistic/utils/change_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberSelected = false;
  bool isTapped = false;
  bool isObscure = true;
  final LoginBloc loginBloc = LoginBloc();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final LocalAuthentication auth;
  bool _isSupported = false;
  bool isFingerprintAuthenticated = false;

  @override
  void initState() {
    super.initState();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      debugPrint('AUTHEN: $isSupported');
      setState(() {
        _isSupported = isSupported;
      });
    });
    checkRemembered();
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    debugPrint('AUTHEN: $availableBiometrics');

    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticate = await auth.authenticate(
          localizedReason: 'Authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));

      isFingerprintAuthenticated = authenticate;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void checkRemembered() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool? isRemembered = preferences.getBool('isRemembered');

    if (isRemembered != null) {
      String? email = preferences.getString('email');
      String? password = preferences.getString('password');

      emailController.text = email!;
      passwordController.text = password!;
      isRememberSelected = true;
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {});
    }
  }

  void checkBiometricAllow(double screenWidth, double screenHeight) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? biometricsTurnOn = await preferences.getBool('biometricsActivated');
    if (biometricsTurnOn != null) {
      await _getAvailableBiometric();
      await _authenticate();
      if (isFingerprintAuthenticated) {
        loginBloc.add(LoginButtonClickedEvent(
            email: 'toanquoc@gmail.com', password: 'toanquoc'));
      }
    } else {
      showBiometricsAlert(screenWidth, screenHeight);
    }
  }

  void showBiometricsAlert(double screenWidth, double screenHeight) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: const Text(
                'Thông báo',
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 255, 43, 43),
                    fontWeight: FontWeight.w400),
              ),
            ),
            content: Container(
              height: height * 0.15,
              width: width,
              child: Center(
                child: Text(
                  'Tính năng này chưa được kích hoạt. Hãy đăng nhập và kích hoạt trong phần cài đặt',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 43, 43),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            actions: [
              Center(
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 80, 80)),
                    child: Center(
                      child: Text(
                        'Đóng',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }

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
                      id: state.id,
                      fullName: state.fullName,
                      email: state.email,
                      phoneNumber: state.phoneNumber,
                      imageUrl: state.imageUrl)));
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
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
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
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
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
                                  isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 26,
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRememberSelected = !isRememberSelected;
                            });
                          },
                          child: Row(children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isRememberSelected,
                                  onChanged: (bool? newValue) async {
                                    isRememberSelected = newValue!;
                                    if (isRememberSelected) {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setBool(
                                          'isRemembered', isRememberSelected);
                                    } else {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.remove('isRemembered');
                                    }
                                    setState(() {});
                                  },
                                  side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                          color: Colors.white, width: 1.0)),
                                  activeColor:
                                      const Color.fromARGB(255, 255, 102, 102),
                                  checkColor: Colors.white,
                                ),
                                SizedBox(height: screenHeight * 0.08),
                                Text(
                                  'Ghi nhớ đăng nhập',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context, ChangePage.changePage(ResetOptionsScreen()));
                              },
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 0.8
                                    ),
                              ),
                            )
                          ]),
                        ),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                        onTap: () async {
                          checkBiometricAllow(screenWidth, screenHeight);
                        },
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
              )),
        );
      },
    );
  }

  void alertFailed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Đăng nhập thất bại')));
  }
}
