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
  String level = '初級';

  final AudioPlayer _audioPlayer = AudioPlayer(); // 🎵 音声プレイヤー
  bool isUploading = false;

  bool isValidAnswer(String value) {
    return RegExp(r'^[\u3040-\u309F\u30A0-\u30FFA-Z]+$').hasMatch(value);
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
    if (selectedFileName == null || fileBytes == null || quizText.isEmpty || !isValidAnswer(answer)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('すべての項目を正しく入力してください。')),
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
      ..fields['quiz_level'] = level
      ..files.add(http.MultipartFile.fromBytes('quiz_MP3', fileBytes!, filename: selectedFileName));

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
  void dispose() {
    _audioPlayer.dispose(); // 🎵 メモリ解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("イントロクイズの登録ページ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: pickMp3File,
              child: const Text('MP3ファイルを選択'),
            ),
            if (selectedFileName != null) ...[
              Text("選択済: $selectedFileName"),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: playSelectedMp3,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("再生する"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _audioPlayer.stop();
                    },
                    icon: const Icon(Icons.stop),
                    label: const Text("停止"),
                  ),
                ],
              ),
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
