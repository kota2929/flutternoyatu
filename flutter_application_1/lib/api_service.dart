import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quiz.dart';

Future<List<Quiz>> fetchQuizzes(String level) async {
  final url = Uri.parse('http://localhost/quiz_api/get_quiz.php?level=$level');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((q) => Quiz.fromJson(q)).toList();
  } else {
    throw Exception('クイズの取得に失敗しました');
  }
}
