import 'package:flutter/material.dart';
// import 'package:network_quality_statistic/presentation/screens/landing_screen.dart';
// import 'package:network_quality_statistic/presentation/screens/setting_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_quality_statistic/presentation/screens/login_screen.dart';
import 'data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final sharedPreferences = await SharedPreferences.getInstance();
  // final fullName = sharedPreferences.getString('username') ?? '';
  // final email = sharedPreferences.getString('email') ?? '';
  // final phoneNumber = sharedPreferences.getString('phoneNumber') ?? '';
  // final imageUrl = sharedPreferences.getString('imageUrl') ?? '';

  final userRepository = UserRepository();
  await userRepository.insertUsersFromJsonFile('assets/user_data.json');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // String fullName;
  // String email;
  // String phoneNumber;
  // String imageUrl;

  // MyApp(
  //     {required this.fullName,
  //     required this.email,
  //     required this.phoneNumber,
  //     required this.imageUrl});

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network quality statistic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   '/landing':(context) {
      //     return LandingScreen(
      //         fullName: fullName,
      //         email: email,
      //         phoneNumber: phoneNumber,
      //         imageUrl: imageUrl);
      //   },
      //   '/setting': (context) {
      //     return SettingScreen(
      //         fullName: fullName,
      //         email: email,
      //         phoneNumber: phoneNumber,
      //         imageUrl: imageUrl);
      //   }
      // },
    );
  }
}
