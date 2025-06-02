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
  String quizAnswerReal = '';
  String level = '初級';
  bool isUploading = false;

  bool isValidAnswer(String value) {
      // return RegExp(r'^[ぁ-んァ-ンA-Z。]+$').hasMatch(value);
        return RegExp(r'^[ぁ-んA-Z。]+$').hasMatch(value);
  }

  Future<void> uploadTextQuiz() async {
    

// 1. 必須項目の未入力チェック
  if (quizText.isEmpty || answer.isEmpty || quizAnswerReal.isEmpty || level.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('すべての項目を入力してください。')),
    );
    return;
  }

  // 2. 回答形式のチェック（ひらがな、カタカナ、英大文字のみ）
  if (!isValidAnswer(answer)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('回答は「ひらがな」「英字大文字」「。」のみで記述してください。')),
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
        'quiz_answer_real':quizAnswerReal,
        'quiz_level': level,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('登録成功！')),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
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
      backgroundColor: const Color(0xFF9932CC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "テキストクイズの登録ページ",
          style: TextStyle(
            color: Color(0xFF9932CC),
            fontFamily: 'PixelMplus',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF9932CC)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            children: [
              TextFormField(
                maxLines: 5,
                style: const TextStyle(fontFamily: 'PixelMplus'),
                decoration: const InputDecoration(
                  labelText: "問題文",
                  labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => quizText = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(fontFamily: 'PixelMplus'),
                decoration: const InputDecoration(
                  labelText: "回答（ひらがな/カタカナ/大文字英字 /。のみ）",
                  labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => answer = value,
              ),

              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(fontFamily: 'PixelMplus'),
                decoration: const InputDecoration(
                  labelText: "実際の回答（形式事由）",
                  labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                  border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => quizAnswerReal = value,
                ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: level,
                style: const TextStyle(fontFamily: 'PixelMplus', color: Colors.black),
                items: ['初級', '中級', '上級', 'ゲキムズ'].map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level, style: const TextStyle(fontFamily: 'PixelMplus')),
                  );
                }).toList(),
                onChanged: (val) => setState(() => level = val!),
                decoration: const InputDecoration(
                  labelText: "難易度",
                  labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isUploading ? null : uploadTextQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUploading ? Colors.grey : const Color(0xFF9932CC),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'PixelMplus',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: Text(isUploading ? "アップロード中…" : "登録"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
