import 'package:flutter/material.dart';
import 'package:network_quality_statistic/presentation/screens/login_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  deleteDatabase('path');

  final userRepository = UserRepository();
  await userRepository.insertUsersFromJsonFile('assets/user_data.json');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
    );
  }
}
