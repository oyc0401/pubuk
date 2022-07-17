import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messenger extends StatefulWidget {
  const Messenger({Key? key}) : super(key: key);

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "채팅",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(40),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.search),
                  Text(
                    "오유찬",
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: widgets(),
            ),
          )
        ],
      ),
    );
  }

  List<String> getUsers() {
    return ["이도경", '송성학', '장원영', '윈터'];
  }


  List<Widget> widgets() {
    List names = getUsers();
    List<Widget> widgets = [];

    for (String name in names) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(name),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/550x/34/c2/f9/34c2f984350ed23d1efa7094d7923c5a.jpg'),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}







/// 4명이 위젯 만드는법
///
/// firebase 관리 2
/// UI 개발 2
///
///
///
///
