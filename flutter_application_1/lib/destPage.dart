import 'package:flutter/material.dart';

class DestPage extends StatelessWidget {
  final List<String> items = [
    "項目1",
    "項目2",
    "項目3",
    "項目4",
    "項目5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("一覧ページ"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.star, color: Colors.blue),
            title: Text(
              items[index],
              style: TextStyle(fontSize: 18),
            ),
            // onTap: () {
            //   // リストアイテムがタップされた時の処理
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text("${items[index]}が選択されました")),
            //   );
            // },
          );
        },
      ),
    );
  }
}
