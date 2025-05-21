import 'package:flutter/material.dart';

class QuizTypeSelectionPage extends StatelessWidget {
  const QuizTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ作成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '作成するクイズを選んでください',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/createIntroQuiz');
  },
  child: const Text('イントロクイズ作成'),
),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createImageQuiz');
              },
              child: const Text('画像付きクイズ作成'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createTextQuiz');
              },
              child: const Text('文章クイズ作成'),
            ),
          ],
        ),
      ),
    );
  }
}
