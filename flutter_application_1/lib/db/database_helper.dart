
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'zutomayo_quiz.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quiz (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        genre TEXT,
        question TEXT,
        correct_answer TEXT,
        difficulty TEXT
      )
    ''');
  }

  // クイズを追加する
  Future<int> insertQuiz(Map<String, dynamic> quiz) async {
    final db = await database;
    return await db.insert('quiz', quiz);
  }

  // クイズをすべて取得
  Future<List<Map<String, dynamic>>> getAllQuiz() async {
    final db = await database;
    return await db.query('quiz');
  }

  // 難易度フィルター付きで取得
  Future<List<Map<String, dynamic>>> getQuizByDifficulty(String difficulty) async {
    final db = await database;
    return await db.query('quiz', where: 'difficulty = ?', whereArgs: [difficulty]);
  }

  // ジャンルで絞り込む
  Future<List<Map<String, dynamic>>> getQuizByGenre(String genre) async {
    final db = await database;
    return await db.query('quiz', where: 'genre = ?', whereArgs: [genre]);
  }
}