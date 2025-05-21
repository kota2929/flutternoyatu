import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quiz_app.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quizzes (
        quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_genre TEXT NOT NULL,
        quiz_MP3 TEXT,
        quiz_image TEXT,
        quiz_text TEXT NOT NULL,
        quiz_answer TEXT NOT NULL,
        quiz_level TEXT NOT NULL
      );
    ''');
  }

  // 追加：クイズを登録するメソッド
  Future<int> insertQuiz(Map<String, dynamic> quiz) async {
    final db = await database;
    return await db.insert('quizzes', quiz);
  }

  // クイズをすべて取得
  Future<List<Map<String, dynamic>>> getAllQuizzes() async {
    final db = await database;
    return await db.query('quizzes');
  }
}
