import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class QuizRegisterImagePage extends StatefulWidget {
  const QuizRegisterImagePage({Key? key}) : super(key: key);

  @override
  State<QuizRegisterImagePage> createState() => _QuizRegisterImagePageState();
}

class _QuizRegisterImagePageState extends State<QuizRegisterImagePage> {
  String? selectedFileName;
  Uint8List? fileBytes;
  String quizText = '';
  String answer = '';
  String quizAnswerReal = '';
  String level = '初級';
  bool isUploading = false;

  bool isValidAnswer(String value) {
    // return RegExp(r'^[ぁ-んァ-ンA-Z。]+$').hasMatch(value);
        return RegExp(r'^[ぁ-んA-Z。ー]+$').hasMatch(value);
  }

  Future<void> pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null) {
      final pickedFile = result.files.single;
      setState(() {
        selectedFileName = pickedFile.name;
        fileBytes = pickedFile.bytes;
      });
    }
  }

  Future<void> uploadQuiz() async {
    if (selectedFileName == null || fileBytes == null || quizText.isEmpty || answer.isEmpty || quizAnswerReal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('すべての項目を正しく入力してください。')),
      );
      return;
    }

    if (!isValidAnswer(answer)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('回答は「ひらがな」「英字大文字」「。」のみで記述してください。')),
      );
      return;
    }


    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse("http://localhost/quiz_api/uplode_Imagequiz.php");
    final request = http.MultipartRequest("POST", uri)
      ..fields['quiz_genre'] = '画像クイズ'
      ..fields['quiz_text'] = quizText
      ..fields['quiz_answer'] = answer
      ..fields['quiz_answer_real'] = quizAnswerReal
      ..fields['quiz_level'] = level
      ..files.add(http.MultipartFile.fromBytes('quiz_image', fileBytes!, filename: selectedFileName));

    final response = await request.send();

if (response.statusCode == 200) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('登録成功！')),
  );
  await Future.delayed(const Duration(seconds: 1)); // スナックバーが見えるように少し待つ
  Navigator.pop(context); // 前のページに戻る
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
    backgroundColor: const Color(0xFF9932CC), // 背景色
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "画像クイズの登録ページ",
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
            Center(
              child: ElevatedButton(
                onPressed: pickImageFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9932CC),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'PixelMplus',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('画像ファイルを選択'),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedFileName != null && fileBytes != null) ...[
              Text(
                "選択済: $selectedFileName",
                style: const TextStyle(
                  fontFamily: 'PixelMplus',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Image.memory(fileBytes!, height: 200),
              const SizedBox(height: 20),
            ],
            TextFormField(
              maxLines: 5,
              style: const TextStyle(
                fontFamily: 'PixelMplus',
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "問題文",
                labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) => quizText = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(
                fontFamily: 'PixelMplus',
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "回答（ひらがな/大文字英字のみ）",
                labelStyle: TextStyle(fontFamily: 'PixelMplus'),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
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
              style: const TextStyle(
                fontFamily: 'PixelMplus',
                color: Colors.black,
              ),
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
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: isUploading ? null : uploadQuiz,
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
