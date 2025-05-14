import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'dart:typed_data';  // Web用にbytesを扱うためのインポート
import 'package:flutter/foundation.dart';  // kIsWebのためのインポート

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
  File? selectedAudio;
  Uint8List? selectedAudioBytes;  // Web用のバイトデータ
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (kIsWeb) {
          // Webの場合、pathではなくbytesを使用
          selectedAudioBytes = result.files.single.bytes;
          selectedAudio = null;  // Webの場合、Fileは使わない
        } else {
          // モバイルの場合、Fileを使う
          selectedAudio = File(result.files.single.path!);
          selectedAudioBytes = null;  // モバイルの場合、bytesは使わない
        }
      });
    }
  }

  void playAudio() async {
    if (kIsWeb && selectedAudioBytes != null) {
      // Webの場合、MemorySourceを使ってバイトデータで再生
      await audioPlayer.play(BytesSource(selectedAudioBytes!));
    } else if (selectedAudio != null) {
      // モバイルの場合、DeviceFileSourceを使ってファイルから再生
      await audioPlayer.play(DeviceFileSource(selectedAudio!.path));
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
                  selectedAudio = null;
                  selectedAudioBytes = null;  // ジャンル変更時にオーディオデータもクリア
                });
              },
              hint: const Text(
                'ジャンルを選んでください',
                style: TextStyle(fontFamily: 'PixelMplus'),
              ),
            ),
            const SizedBox(height: 20),

            // イントロクイズ用のUI
            if (selectedGenre == 'イントロクイズ') ...[
              const Text(
                'Mp3ファイルを選択してください',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickAudioFile,
                child: const Text('ファイルを選択'),
              ),
              if (selectedAudio != null || selectedAudioBytes != null) ...[
                const SizedBox(height: 10),
                Text(
                  selectedAudio != null
                      ? '選択されたファイル：${selectedAudio!.path.split('/').last}'
                      : '選択されたファイル：${selectedAudioBytes != null ? "バイトデータ" : "なし"}',
                ),
                ElevatedButton.icon(
                  onPressed: playAudio,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('試し聴き'),
                ),
              ] 
            ]
          ],
        ),
      ),
    );
  }
}
