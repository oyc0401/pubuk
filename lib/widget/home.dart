import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/community.dart';
import 'package:flutterschool/page/setting.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'lunch.dart';
import 'timetable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future TimeTableFetchPost() async {
    var now = DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var Grade = prefs.getInt('Grade') ?? 1;
    var Class = prefs.getInt('Class') ?? 1;
    const SchoolCode = 7530072;

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&"
        "SD_SCHUL_CODE=$SchoolCode&GRADE=$Grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("home: 시간표 json 파싱 완료 $uri");
      setState(() {
        table_post = Post.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  Post table_post = Post.fromJson({});

  @override
  void initState() {
    super.initState();
    TimeTableFetchPost();
    Firebase.initializeApp();
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: TimeTableFetchPost,
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(12.0),
                child: TimeTable(post: table_post)),
            const SizedBox(height: 30),
            CupertinoButton(
                child: Text('게시판 이동'),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => community()));
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
}
