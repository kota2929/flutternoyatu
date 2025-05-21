import 'package:flutter/material.dart';
import 'package:flutter_application_1/CreateIntoroQuiz.dart';
import 'package:flutter_application_1/CreateImageQuiz.dart';
import 'package:flutter_application_1/CreateTextQuiz.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizRegisterPage()),
                );
              },
              child: const Text('イントロクイズ作成'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizRegisterImagePage()),
                );
              },
              child: const Text('画像付きクイズ作成'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizRegisterTextPage()),
                );
              },
              child: const Text('文章クイズ作成'),
            ),
          ],
        ),
      ),
    );
  }
}