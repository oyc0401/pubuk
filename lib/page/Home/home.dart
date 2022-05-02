import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/Community/community.dart';
import 'package:flutterschool/page/Home/timet.dart';
import 'package:flutterschool/page/Profile/myinfo.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../../DB/UserData.dart';
import '../../DB/Userboxorigin.dart';

import 'lunch.dart';
import 'timetable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 로딩전 초기값
  Widget table = Column(
    children: [
      SizedBox(
        height: 30,
      ),
      Container(
        height: 450,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    ],
  );

  /// 로딩전 초기값





  @override
  void initState() {
    super.initState();
    init();
  }



  init() async{
    //TimeTableFetchPost();
    Firebase.initializeApp().then((value) {
      //getInstance();
    });


    SaveKey key = await SaveKey.Instance();
    UserData userData = key.userData();
    int Grade = userData.Grade;
    int Class = userData.Class;
    int SchoolCode = 7530072;
    timet tim=timet(Grade: Grade, Class: Class, SchoolCode: SchoolCode);
    Map<String, dynamic> map=await  tim.getJson();
    print(map);


    setState(() {
      table = Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [Text('$Grade학년 $Class반')],
            ),
          ),
          TimeTable(MMMap: tim.timeMap(map)),
        ],
      );
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
            Padding(padding: EdgeInsets.all(12.0), child: table),
            CupertinoButton(
                child: Text('게시판 이동'), onPressed: NavigateCommunity),
            const Padding(padding: EdgeInsets.all(12.0), child: Lunch()),
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
