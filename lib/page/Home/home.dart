import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/Community/community.dart';
import 'package:flutterschool/page/Home/timetable.dart';
import 'package:flutterschool/page/Profile/myinfo.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../../DB/UserData.dart';
import '../../DB/Userboxorigin.dart';

import 'lunch.dart';

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

  init() async{
    Firebase.initializeApp().then((value) {
      //getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
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
  Widget TimeTableSection(){
    return const Padding(padding: EdgeInsets.all(12.0), child: timetable());
  }
  Widget CommunitySection(){

    return CupertinoButton(
        child: Text('게시판 이동'), onPressed: NavigateCommunity);
  }

  Widget LunchSection(){
    return const Padding(padding: EdgeInsets.all(12.0), child: Lunch());
  }


  NavigateInfo() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => myinfo()));
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
