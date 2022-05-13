import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/setting.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          onPressed: NavigateSetting,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  ListView body() {
    return ListView(
      children: [
        TimeTableSection(),
        CommunitySection(),
        LunchSection(),
        CupertinoButton(
            child: const Text('저장소 확인'),
            onPressed: () {
              checkKey();
            }),
        const SizedBox(height: 30),
        Container(
          height: 400,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget TimeTableSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: timetable(),
    );
  }

  Widget CommunitySection() {
    return CupertinoButton(
      child: const Text('게시판 이동'),
      onPressed: NavigateCommunity,
    );
  }

  Widget LunchSection() {
    print("런치");
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Lunch(),
    );
  }

  void NavigateInfo() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const myinfo(),
      ),
    );

    setState(() {});
  }

  void NavigateSetting() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const setting(),
      ),
    );

    setState(() {});
  }

  void NavigateCommunity() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => community(),
      ),
    );
  }

  Future<void> checkKey() async {
    SaveKeyHandler key = await SaveKeyHandler.Instance();
    key.printAll();
  }
}
