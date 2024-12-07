import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper db = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = documentsDirectory.path + 'sms.db';
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Sms (id INTEGER PRIMARY KEY, body TEXT)');
        });
  }

  insertSMS(String body) async {
    final db = await database;
    final res = await db.rawInsert('INSERT INTO Sms (body) VALUES (?)', [body]);
    return res;
  }

  Future<List<String>> getAllSMS() async {
    final db = await database;
    final res = await db.query("Sms");
    List<String> list =
    res.isNotEmpty ? res.map((c) => c['body'] as String).toList() : [];
    return list;
  }
}
