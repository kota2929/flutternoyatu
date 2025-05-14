import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class CreateQuizPage extends StatefulWidget{
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}


class _CreateQuizPageState extends State<CreateQuizPage>{
   final List<String> genres = [
    '画像付き問題',
    '文章問題',
    'イントロクイズ',
     ];

   String? selectedGenre;
   File? selectedAudio;
   final AudioPlayer audioPlayer = AudioPlayer();

   @override
    Widget build(BuildContext context){
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
              children:[
                const Text(
                  'ジャンルを選択してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'pixelMplus',
                    ),
                ),
                const SizedBox(height:8),
                DropdownButtonFormField<String>(
                  value: selectedGenre,
                 
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: genres.map((genre){
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(
                        genre,
                        style: const TextStyle(fontFamily: 'pixelMplus'),
                      ),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState((){
                      selectedGenre = value!;
                      //TODO：選択ジャンルに合わせて入力UIを出し分け
                    });
                  },
                  hint: const Text(
                    'ジャンルを選んでください',
                    style: TextStyle(fontFamily: 'PixelMplus'),
                  ),
                  ),
              ],
              ),
              ),

          );

    }
  }
