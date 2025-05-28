import 'package:flutter/material.dart';
import 'package:flutter_application_1/CreateIntoroQuiz.dart';
import 'package:flutter_application_1/CreateImageQuiz.dart';
import 'package:flutter_application_1/CreateTextQuiz.dart';

class QuizTypeSelectionPage extends StatelessWidget {
  const QuizTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9932CC), // 背景色変更
      appBar: AppBar(
        title: const Text(
          'クイズ作成',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'PixelMplus',
            fontSize: 32,
          ),
        ),
        backgroundColor: const Color(0xFF9932CC),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '作成するクイズを選んでください',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'PixelMplus',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              _buildStyledButton(
                context,
                label: 'イントロクイズ作成',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizRegisterPage()),
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildStyledButton(
                context,
                label: '画像付きクイズ作成',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizRegisterImagePage()),
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildStyledButton(
                context,
                label: '文章クイズ作成',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizRegisterTextPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,  // ← 横幅を調整したいサイズに変更
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF9932CC),
          textStyle: const TextStyle(
            fontSize: 20,
            fontFamily: 'PixelMplus',
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
