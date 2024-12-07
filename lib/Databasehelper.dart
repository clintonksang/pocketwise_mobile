import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sms_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE messages(id INTEGER PRIMARY KEY, text TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertMessage(String message) async {
    final db = await database;
    await db.insert(
      'messages',
      {'text': message},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> messages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return maps[i]['text'];
    });
  }
}
