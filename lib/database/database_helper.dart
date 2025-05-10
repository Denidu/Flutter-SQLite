import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static Database? _database;
  static const String DB_NAME = 'contacts.db';
  static const String TABLE_NAME = 'contacts';
  static const String COL_ID = 'id';
  static const String COL_NAME = 'name';
  static const String COL_PHONE = 'phone';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME(
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COL_NAME TEXT,
        $COL_PHONE TEXT
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(TABLE_NAME, contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(
      TABLE_NAME,
      where: '$COL_ID = ?',
      whereArgs: [id],
    );
  }
}
