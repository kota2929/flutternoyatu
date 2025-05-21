import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizRegisterTextPage extends StatefulWidget {
  const QuizRegisterTextPage({Key? key}) : super(key: key);

  @override
  State<QuizRegisterTextPage> createState() => _QuizRegisterTextPageState();
}

class _QuizRegisterTextPageState extends State<QuizRegisterTextPage> {
  String quizText = '';
  String answer = '';
  String level = '初級';
  bool isUploading = false;

  bool isValidAnswer(String value) {
    return RegExp(r'^[\u3040-\u309F\u30A0-\u30FFA-Z]+$').hasMatch(value);
  }

  Future<void> uploadTextQuiz() async {
    if (quizText.isEmpty || !isValidAnswer(answer)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('問題文と正しい形式の回答を入力してください。')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse("http://localhost/quiz_api/uplode_Textquiz.php");
    final response = await http.post(
      uri,
      body: {
        'quiz_genre': 'テキストクイズ',
        'quiz_text': quizText,
        'quiz_answer': answer,
        'quiz_level': level,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登録成功！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登録失敗。')),
      );
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("テキストクイズの登録ページ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(labelText: "問題文"),
              onChanged: (value) => quizText = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: "回答（ひらがな/カタカナ/大文字英字のみ）"),
              onChanged: (value) => answer = value,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: level,
              items: ['初級', '中級', '上級', 'ゲキムズ'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (val) => setState(() => level = val!),
              decoration: const InputDecoration(labelText: "難易度"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUploading ? null : uploadTextQuiz,
              child: Text(isUploading ? "アップロード中…" : "登録"),
            ),
          ],
        ),
      ),
    );
  }
}
