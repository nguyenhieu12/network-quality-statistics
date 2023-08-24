import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../models/user_model.dart';

class UserRepository {
  Future<void> insertUser(UserModel user) async {
    final database = await DatabaseHepler.db();
    await database.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertUsersFromJsonFile(String filePath) async {
    final jsonString = await rootBundle.loadString(filePath);
    final List<dynamic> jsonList = json.decode(jsonString);

    for (final json in jsonList) {
      final user = UserModel.fromMap(json);
      await insertUser(user);
    }
  }

  static Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await DatabaseHepler.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DatabaseHepler.db();
    return db.query('users');
  }

  static Future updateUser(int id, String newImageUrl, String newPhoneNumber) async {
    final db = await DatabaseHepler.db();

    final data = {
      'phoneNumber': newPhoneNumber,
      'imageUrl': newImageUrl,
    };

    await db.update('users', data, where: "id = ?", whereArgs: [id]);

    await db.close();
  }
}
