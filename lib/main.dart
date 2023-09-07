import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:network_quality_statistic/presentation/screens/login_screen.dart';
import 'package:network_quality_statistic/services/messaging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'data/database/database.dart';
import 'data/repositories/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  await Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  await checkAndCreateDatabase();

  await Messaging().initNotifications();

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

Future<void> checkAndCreateDatabase() async {
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  var dbPath = join(documentDirectory.path, "network_statistic.db");

  if (!(await databaseExists(dbPath))) {
    Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await DatabaseHepler.createUserTable(db);

        final userRepository = UserRepository();
        await userRepository.insertUsersFromJsonFile('assets/data/user_data.json');
      },
    );
  }
}
