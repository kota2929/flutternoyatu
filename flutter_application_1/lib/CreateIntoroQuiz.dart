import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class QuizRegisterPage extends StatefulWidget {
  const QuizRegisterPage({Key? key}) : super(key: key);

  @override
  State<QuizRegisterPage> createState() => _QuizRegisterPageState();
}

class _QuizRegisterPageState extends State<QuizRegisterPage> {
  String? selectedFileName;
  Uint8List? fileBytes;
  String quizText = '';
  String answer = '';
  String quizAnswerReal = '';
  String level = '初級';

  final AudioPlayer _audioPlayer = AudioPlayer(); // 🎵 音声プレイヤー
  bool isUploading = false;

  bool isValidAnswer(String value) {
    // return RegExp(r'^[ぁ-んァ-ンA-Z。]+$').hasMatch(value);
      return RegExp(r'^[ぁ-んA-Z。]+$').hasMatch(value);
  }

  Future<void> pickMp3File() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
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

  Future<void> playSelectedMp3() async {
    try {
      await _audioPlayer.stop();
      if (kIsWeb && fileBytes != null) {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.dataFromBytes(
              fileBytes!,
              mimeType: 'audio/mpeg',
            ),
          ),
        );
      } else if (!kIsWeb && selectedFileName != null) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['mp3'],
        );
        if (result != null && result.files.single.path != null) {
          await _audioPlayer.setFilePath(result.files.single.path!);
        }
      }
      await _audioPlayer.play();
    } catch (e) {
      print("再生エラー: $e");
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
        const SnackBar(content: Text('回答は「ひらがな」英字大文字」「。」のみで記述してください。')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse("http://localhost/quiz_api/uplode_Intoroquiz.php");
    final request = http.MultipartRequest("POST", uri)
      ..fields['quiz_genre'] = 'イントロ'
      ..fields['quiz_text'] = quizText
      ..fields['quiz_answer'] = answer
      ..fields['quiz_answer_real'] = quizAnswerReal
      ..fields['quiz_level'] = level
      ..files.add(http.MultipartFile.fromBytes('quiz_MP3', fileBytes!, filename: selectedFileName));

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
  void dispose() {
    _audioPlayer.dispose(); // 🎵 メモリ解放
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF9932CC), // 背景色
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "イントロクイズの登録ページ",
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
                onPressed: pickMp3File,
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
                child: const Text('MP3ファイルを選択'),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedFileName != null) ...[
              Text(
                "選択済: $selectedFileName",
                style: const TextStyle(
                  fontFamily: 'PixelMplus',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: playSelectedMp3,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("再生する"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontFamily: 'PixelMplus'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async => await _audioPlayer.stop(),
                    icon: const Icon(Icons.stop),
                    label: const Text("停止"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontFamily: 'PixelMplus'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
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
                labelText: "回答（ひらがな/カタカナ/大文字英字のみ）",
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
