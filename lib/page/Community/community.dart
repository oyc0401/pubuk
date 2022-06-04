import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../../Server/FireTool.dart';
import '../../tools/Time.dart';
import 'view.dart';
import 'write.dart';

class community extends StatefulWidget {
  community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  /// 로딩전 초기값
  String finalDate = '2022-01-15 00:09:27.614909';
  List<Widget> widgetList = [
    const SizedBox(
        height: 400, child: Center(child: CircularProgressIndicator()))
  ];

  /// 로딩전 초기값



  Future readFirst() async {
    print('readFirst');
    //reset All DATA
    await FireTool.readFirstMap().then((map) {
      String firstvalue = map['date'];
      print("처음 날짜: $firstvalue");
      widgetList = [];
      widgetList.add(textWidget(map));
      finalDate = firstvalue;
    });
  }

  Future readPage() async {
    print('readPage');
    await FireTool.readTexts(finalDate).then((value) {
      value.forEach((map) {
        finalDate = map['date'];
        widgetList.add(textWidget(map));
      });
    });
    setState(() {});

  }

  Future reset() async {
    print('reset');
    await readFirst();
    await readPage();

  }

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판'),
        actions: [
          IconButton(
            onPressed: () {
              NavigateWrite();
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [...widgetList],
      ),
    );
  }

  Widget textWidget(Map json) {
    print("json2Widget");
    //print(json);

    String date = Time.timeDifferent(json['date']);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print('눌렀어');
            NavigateView(json['date']);
          },
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                nickNameSection(json['nickname'], date),
                contextSection(json['text']),
                likeSection(json['heart'], json['comment']),
              ],
            ),
          ),
        ),
        Container(
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget nickNameSection(String nickname, String date) {
    return Row(
      children: [
        Text(nickname,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black)),
        Text(date,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  Container contextSection(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget likeSection(int like, int comment) {
    String Like = like.toString();
    String Comment = comment.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Row(
            children: [
              const Icon(
                Icons.thumb_up,
                size: 15,
              ),
              Text(Like),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.comment,
              size: 15,
            ),
            Text(Comment),
          ],
        ),
      ],
    );
  }

  void NavigateView(String url) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => view(url: url),
      ),
    );
    reset();
  }

  NavigateWrite() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const write(),
      ),
    );
    reset();
  }
}
