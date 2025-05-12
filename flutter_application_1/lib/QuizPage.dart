import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final String difficulty;

  const QuizPage({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$difficultyクイズ'),
      ),
      body: Center(
        child: Text(
          '$difficulty のクイズページです',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
