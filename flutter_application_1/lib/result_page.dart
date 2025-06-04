import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text('結果発表',
      style: const TextStyle(
        fontFamily: 'PixelMplus',)),
      centerTitle: true,
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('あなたの正解数は $score / 5 問です！', 
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'PixelMplus'
              )
            
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // クイズ開始画面へ戻る
              },
              child: const Text('トップに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
