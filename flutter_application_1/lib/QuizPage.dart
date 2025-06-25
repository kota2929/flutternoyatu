import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/result_page.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:audioplayers/audioplayers.dart';



class QuizPage extends StatefulWidget {
  final String difficulty;

  const QuizPage({super.key, required this.difficulty});

  @override
  State<QuizPage> createState() => _QuizPageState();


}

class _QuizPageState extends State<QuizPage> {
  TextEditingController answerController = TextEditingController();

  List<dynamic> quizzes = [];
  int currentIndex = 0;
  String userAnswer = '';
  bool isLoading = true;
 html.AudioElement? _audio;
  bool isPlaying = false;
  List<Map<String, String>> quizResults = [];

  bool isValidFormat(String input) {
  // final regExp = RegExp(r'^[ぁ-んァ-ンA-Z。ー]+$');
  final regExp = RegExp(r'^[ぁ-んA-Z。ー]+$');
  return regExp.hasMatch(input);

  
}

void checkAnswer(BuildContext context) {
  final currentQuiz = quizzes[currentIndex];
  final correctAnswer = currentQuiz['quiz_answer'];

  if (!isValidFormat(userAnswer)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('使える文字は「ひらがな・英大文字・。」のみです')),
    );
    return;
  }

  final isCorrect = userAnswer.trim() == correctAnswer.trim();

  // モーダル表示
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(
            isCorrect ? Icons.circle : Icons.close,
            color: isCorrect ? Colors.red : Colors.blue,
            size: 36,
          ),
          const SizedBox(width: 8),
          Text(
            isCorrect ? '正解！' : '不正解',
            style: const TextStyle(
              fontFamily: 'PixelMplus',
            ),
            ),
        ],
      ),
      content: Text(
        '正解：${currentQuiz['quiz_answer']}（${currentQuiz['quiz_answer_real']}）',
        style: const TextStyle(
          fontFamily: 'PixelMplus'
        ),
        ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // モーダル閉じる
            answerController.clear();

                // 結果を保存
    quizResults.add({
      'question': currentQuiz['quiz_text'],
      'correct_answer': currentQuiz['quiz_answer'],
      'real_answer': currentQuiz['quiz_answer_real'],
      'user_answer': userAnswer,
    });

            nextQuestion(); // 次の問題へ
          },
          child: const Text(
            '次の問題へ',
            style: const TextStyle(
              fontFamily: 'PixelMplus',
            ),
            ),
        ),
      ],
    ),
  );

  // 正解数カウント
  if (isCorrect) {
    correctCount++;
  }


}


int correctCount = 0;

void nextQuestion() {
  if (currentIndex + 1 < 5) {
    setState(() {
      currentIndex++;
      userAnswer = '';
    });
  } else {
    // 結果ページへ
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => ResultPage(
      score: correctCount,
      results: quizResults,
    ),
  ),
);
  }
}




  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }



void playAudio(String fileName) {
    final url = 'http://localhost/quiz_api/music/$fileName';
    _audio = html.AudioElement(url);
    _audio!
      ..autoplay = true
      ..controls = false;
    _audio!.play();
    setState(() {
      isPlaying = true;
    });

    Future.delayed(const Duration(seconds: 7),(){
      stopAudio();
    });
  }

  void stopAudio() {
    _audio?.pause();
    _audio?.currentTime = 0;
    setState(() {
      isPlaying = false;
    });
  }

    @override
  void dispose() {
    _audio?.pause();
    _audio = null;
    super.dispose();
  }





  Future<void> fetchQuizzes() async {
   final level = widget.difficulty; // 例: "easy", "medium", etc.

final url = Uri.http('localhost', '/quiz_api/get_quiz.php', {
  'level': level,
});
    final response = await http.post(url, body: {'level': widget.difficulty});

    if (response.statusCode == 200) {
      setState(() {
        quizzes = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('データ取得に失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuiz = quizzes[currentIndex];
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.difficulty}クイズ',
        style: const TextStyle(
          fontFamily: 'PixelMplus',
          
        ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 問題番号
            Text(
              '問題 ${currentIndex + 1} / 5',
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'PixelMplus',
                ),
              textAlign: TextAlign.center,
              
            ),
            const SizedBox(height: 20),

            // 画像または音声（MP3）
            if (currentQuiz['quiz_image'] != null &&
                currentQuiz['quiz_image'].toString().isNotEmpty)
              Image.network(
                'http://localhost/quiz_api/image/${currentQuiz['quiz_image']}',
                height: 150,
              )
            else if (currentQuiz['quiz_MP3'] != null &&
         currentQuiz['quiz_MP3'].toString().isNotEmpty)

         
    Column(
      children: [
        
        const Text(
          'イントロ問題', 
          style: const TextStyle(
            fontFamily: 'PixelMplus',
            fontSize: 20,
            )
            ,
          ),
        Row(
          children: [
            ElevatedButton(
              onPressed: isPlaying
                  ? null
                  : () {
                      playAudio(currentQuiz['quiz_MP3']);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,),
              child: const Text('▶ 再生',
              style: const TextStyle(
                fontFamily: 'PixelMplus'
              ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: isPlaying
                  ? () {
                      stopAudio();
                    }
                  : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('■ 停止',
              style: const TextStyle(
                fontFamily: 'PixelMplus',
              ),
              ),
            ),
          ],
        ),
      ],
    ),
            const SizedBox(height: 20),

            // 問題文
            Text(
              currentQuiz['quiz_text'] ,
              style: const TextStyle(
              fontSize: 18,
              fontFamily: 'PixelMplus',
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '\n（回答は英語の部分は英語大文字、そのほかの部分はひらがなで回答してください。記号は「。」のみ使えます）',
              style: TextStyle(
                fontSize: 14,
                fontFamily:'PixelMplus',
                color:Colors.grey,
              )
            ),

            // 回答入力欄
            TextField(
              controller: answerController,
              onChanged: (value) => userAnswer = value,
              style: const TextStyle(
                fontFamily: 'PixelMplus',
              ),
              decoration: const InputDecoration(
                labelText: '答えを入力',
                labelStyle: TextStyle(
                  fontFamily: 'PixelMplus',
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 回答ボタン（まだ正誤判定しない）
ElevatedButton(
  onPressed: () => checkAnswer(context),
  child: const Text('回答する',
  style: const TextStyle(
    fontFamily: 'PixelMplus',
  )),
),

          ],
        ),
      ),
    );
  }
}
