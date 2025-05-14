import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb 用

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final List<String> genres = [
    '画像付き問題',
    '文章問題',
    'イントロクイズ',
  ];

  String? selectedGenre;
  String? selectedFileName;
  Uint8List? fileBytes; // Web用にメモリ内データ保持（任意）

  Future<void> pickMp3File() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
      withData: kIsWeb, // Webではbytesを取得する必要がある
    );

    if (result != null) {
      final pickedFile = result.files.single;

      setState(() {
        selectedFileName = pickedFile.name;
        if (kIsWeb) {
          fileBytes = pickedFile.bytes; // Webではこれを使う
        } else {
          // モバイルでは path を使って File(path) などの操作ができる
          final path = pickedFile.path;
          // 必要であれば File(path) を使って操作可能
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'クイズ作成',
          style: TextStyle(fontFamily: 'PixelMplus'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ジャンルを選択してください',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'pixelMplus',
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedGenre,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: genres.map((genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(
                    genre,
                    style: const TextStyle(fontFamily: 'pixelMplus'),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGenre = value!;
                  selectedFileName = null;
                  fileBytes = null;
                });
              },
              hint: const Text(
                'ジャンルを選んでください',
                style: TextStyle(fontFamily: 'PixelMplus'),
              ),
            ),
            const SizedBox(height: 20),

            // ▼ イントロクイズ用のUIを表示
            if (selectedGenre == 'イントロクイズ') ...[
              const Text(
                'MP3ファイルをアップロード',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickMp3File,
                child: const Text('ファイルを選択'),
              ),
              const SizedBox(height: 10),
              if (selectedFileName != null)
                Text(
                  '選択されたファイル: $selectedFileName',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
