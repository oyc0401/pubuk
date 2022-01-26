import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/community.dart';
import 'package:flutterschool/page/myinfo.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../DB/Userboxorigin.dart';

import 'lunch.dart';
import 'timetable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getInstance() {
    //정보 얻어오기
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser?.uid ?? '로그인 해주세요';
    String email = auth.currentUser?.email ?? '이메일이 없습니다.';
    String displayName = auth.currentUser?.displayName ?? '이름이 없습니다.';
    String photoURL = auth.currentUser?.photoURL ?? '사진이 없습니다.';
    print(id);

    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((value) async {
      SaveKey key = await SaveKey().getInstance();
      key.SetUser(value['ID'], value['nickname'], value['auth'], value['grade'],
          value['class']);
    }).catchError((error) {
      print("Failed to Sign in: $error");
    });
  }

  Future TimeTableFetchPost() async {
    SaveKey key = await SaveKey().getInstance();
      int Grade = key.Grade();
      int Class = key.Class();


    var now = DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5


    const SchoolCode = 7530072;

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&"
        "SD_SCHUL_CODE=$SchoolCode&GRADE=$Grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("home: 시간표 json 파싱 완료 $uri");
      setState(() {
        table =
            Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [Text('$Grade학년 $Class반')],
                  ),
                ),
                TimeTable(post: TableJsonPost.fromJson(json.decode(response.body))),
              ],
            );
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget table =Column(
    children: [
      SizedBox(height: 30,),
      Container(
      height: 450,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    )],
  );

  @override
  void initState() {
    super.initState();
    TimeTableFetchPost();
    Firebase.initializeApp().then((value) {
      getInstance();
    });
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
                  context, CupertinoPageRoute(builder: (context) => myinfo()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: TimeTableFetchPost,
        child: ListView(
          children: [

            Padding(padding: EdgeInsets.all(12.0), child: table),
            const SizedBox(height: 30),
            CupertinoButton(
                child: Text('게시판 이동'),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => community()));
                }),
            CupertinoButton(
                child: Text('저장소 확인'),
                onPressed: () {
                  saving();
                }),
            const SizedBox(height: 30),
            const Padding(padding: EdgeInsets.all(12.0), child: Lunch()
                //Text('ggg')
                ),
            Container(
              height: 400,
            )
          ],
        ),
      ),
    );
  }

  Future saving() async {
    SaveKey key = await SaveKey().getInstance();
    key.printAll();
  }
}
