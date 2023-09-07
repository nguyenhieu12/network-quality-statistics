import 'package:sqflite/sqflite.dart';

class DatabaseHepler {
  static Future<void> createUserTable(Database database) async {
    await database.execute("""
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        email TEXT,
        password TEXT,
        fullName TEXT,
        phoneNumber TEXT,
        role TEXT,
        province TEXT,
        imageUrl TEXT
      )
    """);
  }

  static Future<Database> db() async {
    return openDatabase(
      'network_statistic.db',
      version: 6,
      onCreate: (Database db, int version) async {
        await createUserTable(db);
      },
    );
  }

}
