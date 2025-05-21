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
  String level = '初級';
  bool isUploading = false;

  bool isValidAnswer(String value) {
    return RegExp(r'^[\u3040-\u309F\u30A0-\u30FFA-Z]+$').hasMatch(value);
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
    if (selectedFileName == null || fileBytes == null || quizText.isEmpty || !isValidAnswer(answer)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('すべての項目を正しく入力してください。')),
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
      ..fields['quiz_level'] = level
      ..files.add(http.MultipartFile.fromBytes('quiz_image', fileBytes!, filename: selectedFileName));

    final response = await request.send();

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
      appBar: AppBar(title: const Text("画像クイズの登録ページ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: pickImageFile,
              child: const Text('画像ファイルを選択'),
            ),
            if (selectedFileName != null && fileBytes != null) ...[
              Text("選択済: $selectedFileName"),
              const SizedBox(height: 10),
              Image.memory(fileBytes!, height: 200),
            ],
            const SizedBox(height: 20),
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
              onPressed: isUploading ? null : uploadQuiz,
              child: Text(isUploading ? "アップロード中…" : "登録"),
            ),
          ],
        ),
      ),
    );
  }
}
