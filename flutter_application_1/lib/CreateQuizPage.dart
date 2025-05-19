import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb 用
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';


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

  final AudioPlayer _audioPlayer = AudioPlayer(); // 🎵 プレイヤー

  @override
  void dispose() {
    _audioPlayer.dispose(); // 🎵 メモリ解放
    super.dispose();
  }
  String? selectedDifficulty;
  String? selectedGenre;
  String? selectedFileName;
  Uint8List? fileBytes; // Web用にメモリ内データ保持（任意）

  bool isMusicQuizSelected = false;
bool isLyricsQuizSelected = false;
bool isAlbumQuizSelected = false;
bool isNiraQuizSelected = false;
bool isAnotherQuizSelected = false;


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

Future<void> playSelectedMp3() async {
  try {
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
    body: SingleChildScrollView( // ← スクロール可能に！
      child: Padding(
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

if (selectedFileName != null) ...[
  Text(
    '選択されたファイル: $selectedFileName',
    style: const TextStyle(fontSize: 14),
  ),
  const SizedBox(height: 10),

  Row(
    children: [
      ElevatedButton.icon(
        onPressed: playSelectedMp3,
        icon: const Icon(Icons.play_arrow),
        label: const Text('再生する'),
      ),
      const SizedBox(width: 10),
      ElevatedButton.icon(
        onPressed: () async {
          await _audioPlayer.stop();
        },
        icon: const Icon(Icons.stop),
        label: const Text('停止'),
      ),
    ],
  ),
],

//  const Text(
//               'クイズのタイトルを入力してください',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontFamily: 'pixelMplus',
//               ),
//             ),

//               const SizedBox(height: 10),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: 'クイズのタイトル',
//                   border: OutlineInputBorder(),
//                   ),
//                 ),

const SizedBox(height: 20), // ← これを追加
 const Text(
              '問題文を入力してください',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'pixelMplus',
              ),
            ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(  
                  labelText: '問題文',
                  alignLabelWithHint: true, // ← これが重要！
                  border: OutlineInputBorder(), 
                  ) ,
                  keyboardType: TextInputType.multiline,
                  minLines: 5, // ← 初期の縦幅（行数）を設定
                  maxLines: null,
              ),


const SizedBox(height: 20), // ← これを追加
 const Text(
              'この問題の正解を入力してください（ひらがなorカタカナorアルファベット大文字のみ）',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'pixelMplus',
              ),
            ),

              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'クイズの正解',
                  border: OutlineInputBorder(),
                  ),
                ),

const SizedBox(height: 20), // ← これを追加
 const Text(
              '難易度を選択してください',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'pixelMplus',
              ),
            ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '難易度を選択',
                  border: OutlineInputBorder(),
                ),
                items: const[
                  DropdownMenuItem(value: '初級',child: Text('初級')),
                  DropdownMenuItem(value: '中級',child: Text('中級')),
                  DropdownMenuItem(value: '上級',child: Text('上級')),
                  DropdownMenuItem(value: 'ゲキムズ',child: Text('ゲキムズ')),
                ],
                onChanged: (value){
                  setState((){
                    selectedDifficulty = value!;
                  });
                },
                value: selectedDifficulty,
                ),
              

                const SizedBox(height: 20),
const Text(
  'クイズの種類を選択してください',
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),

CheckboxListTile(
  title: const Text('曲クイズ'),
  value: isMusicQuizSelected,
  onChanged: (bool? value) {
    setState(() {
      isMusicQuizSelected = value ?? false;
    });
  },
),

CheckboxListTile(
  title: const Text('歌詞クイズ'),
  value: isLyricsQuizSelected,
  onChanged: (bool? value) {
    setState(() {
      isLyricsQuizSelected = value ?? false;
    });
  },
),

CheckboxListTile(
  title: const Text('アルバムクイズ'),
  value: isAlbumQuizSelected,
  onChanged: (bool? value) {
    setState(() {
      isAlbumQuizSelected = value ?? false;
    });
  },
),
CheckboxListTile(
  title: const Text('ニラクイズ'),
  value: isNiraQuizSelected,
  onChanged: (bool? value) {
    setState(() {
      isAlbumQuizSelected = value ?? false;
    });
  },
),
CheckboxListTile(
  title: const Text('その他クイズ'),
  value: isAnotherQuizSelected,
  onChanged: (bool? value) {
    setState(() {
      isAlbumQuizSelected = value ?? false;
    });
  },
),



              

            ],
          ],
        ),
      ),
    ),
    );
  }
}
