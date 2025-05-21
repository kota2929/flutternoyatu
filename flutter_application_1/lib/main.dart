// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/HomePage.dart';
// import 'package:flutter_application_1/yogiHomepage.dart';
// import 'package:flutter_application_1/MainPageWidget.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       //画面遷移練習の場合
//       home: YogiHomepage(),
//       //ListViewの場合
//       // home: MainPageWidget(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_application_1/QuizPage.dart';
import 'package:flutter_application_1/CreateQuizPage.dart';
import 'package:flutter_application_1/CreateQuizMenu.dart';
import 'package:flutter_application_1/CreateIntoroQuiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ZutomayoQuizApp());
}

class ZutomayoQuizApp extends StatelessWidget {
  const ZutomayoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZUTOMAYOクイズ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dbStatus = "DB接続確認中...";

  @override
  void initState() {
    super.initState();
    _checkDatabaseConnection();
  }

  Future<void> _checkDatabaseConnection() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/quiz_api/get_quiz.php'),
      );
      if (response.statusCode == 200) {
        setState(() {
          dbStatus = "✅ DB接続成功";
        });
      } else {
        setState(() {
          dbStatus = "⚠️ 接続失敗 (ステータス: ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        dbStatus = "❌ エラー発生: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF9932CC);
    const textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        toolbarHeight: 120,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 90),
            child: Text(
              'ZUTOMAYOクイズ',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PixelMplus',
                fontSize: 32,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '難易度を選んでください',
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontFamily: 'PixelMplus',
            ),
          ),
          const SizedBox(height: 16),
          _buildButton(context, '初級'),
          _buildButton(context, '中級'),
          _buildButton(context, '上級'),
          _buildButton(context, 'ゲキムズ'),
          const SizedBox(height: 32),
          const Divider(thickness: 1, indent: 40, endIndent: 40, color: Colors.white),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const QuizTypeSelectionPage()),
                // テスト用に以下を使用
                MaterialPageRoute(builder: (context) => const QuizRegisterPage()),
              );
            },
            icon: const Icon(Icons.create, color: textColor),
            label: const Text(
              'クイズを作成する',
              style: TextStyle(
                color: textColor,
                fontFamily: 'PixelMplus',
                fontSize: 32,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 24),

          // ↓↓↓ DB接続ステータスの表示（下部に追加）
          Text(
            dbStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'PixelMplus',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static Widget _buildButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(difficulty: label),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF9932CC),
          minimumSize: const Size(220, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'PixelMplus',
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}

