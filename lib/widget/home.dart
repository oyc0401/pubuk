import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/widget/setting.dart';

import 'lunch.dart';
import 'timetable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //async wait 을 쓰기 위해서는 Future 타입을 이용함
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.
    //새로운 정보를 그려내는 곳
    setState(() {
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => setting()));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
             setState(() {
             });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: TimeTable(),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Lunch(),
            ),
            Container(height: 400,)
          ],
        ),
      ),
    );
  }
}
