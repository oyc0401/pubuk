import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../../DB/UserData.dart';
import '../../DB/Userboxorigin.dart';

import '../../DB/saveKey.dart';
import '../Community/community.dart';
import '../Profile/myinfo.dart';
import 'lunch.dart';
import 'timetable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    print("스테이트");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: NavigateInfo,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        children: [
          CupertinoButton(
            child: Text("새로고침"),
            onPressed: () {
              setState(() {});
            },
          ),
          TimeTableSection(),
          CommunitySection(),
          LunchSection(),
          CupertinoButton(
              child: Text('저장소 확인'),
              onPressed: () {
                checkKey();
              }),
          const SizedBox(height: 30),
          Container(
            height: 400,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget TimeTableSection() {
    return const Padding(padding: EdgeInsets.all(12.0), child: timetable());
  }

  Widget CommunitySection() {
    return CupertinoButton(child: Text('게시판 이동'), onPressed: NavigateCommunity);
  }

  Widget LunchSection() {
    return const Padding(padding: EdgeInsets.all(12.0), child: Lunch());
  }

  NavigateInfo() async {
    await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => myinfo()));

    setState(() {});
  }

  NavigateCommunity() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => community()));
  }

  Future checkKey() async {
    SaveKey key = await SaveKey.Instance();
    key.printAll();
  }
}
