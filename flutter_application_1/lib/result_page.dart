import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final List<Map<String, String>> results;

  const ResultPage({
    super.key,
    required this.score,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '結果発表',
          style: TextStyle(fontFamily: 'PixelMplus'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'あなたの正解数は $score / 5 問です！',
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'PixelMplus',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            const Divider(thickness: 1),

            const Text(
              '各問題の正誤結果：',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'PixelMplus',
              ),
            ),
            const SizedBox(height: 10),

            // 各問題の内容と答えを表示
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  final isCorrect = result['user_answer']?.trim() == result['correct_answer']?.trim();
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${index + 1}: ${result['question']}',
                            style: const TextStyle(fontFamily: 'PixelMplus'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'あなたの答え: ${result['user_answer']}',
                            style: TextStyle(
                              fontFamily: 'PixelMplus',
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          Text(
                            '正解: ${result['correct_answer']}（${result['real_answer']}）',
                            style: const TextStyle(fontFamily: 'PixelMplus'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // クイズ開始画面へ戻る
              },
              child: const Text(
                'トップに戻る',
                style: TextStyle(fontFamily: "PixelMplus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
