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
          tab(tim.timeMap(map)),
        ],
      );
    });


  }

  Widget tab(Map MMMap){
    List<TableRow> tableRows() {
      //테이블 총 세로길이 450
      final double height = 60;
      final double halfheight = 30;
      final TextStyle textStyle = const TextStyle(fontSize: 12);

      List<Widget> weekends() {
        List<Widget> list = [];
        list.add(Container(
            height: halfheight,
            child: Center(
                child: Text(
                  " ",
                  style: textStyle,
                ))));
        list.add(Text(
          "월요일",
          textAlign: TextAlign.center,
          style: textStyle,
        ));
        list.add(Text(
          "화요일",
          textAlign: TextAlign.center,
          style: textStyle,
        ));
        list.add(Text(
          "수요일",
          textAlign: TextAlign.center,
          style: textStyle,
        ));
        list.add(Text(
          "목요일",
          textAlign: TextAlign.center,
          style: textStyle,
        ));
        list.add(Text(
          "금요일",
          textAlign: TextAlign.center,
          style: textStyle,
        ));
        return list;
      }


      //"Monday":arrMon,
      //       "Tuesday":arrTue,
      //       "Wednesday":arrWed,
      //       "Thursday":arrThu,
      //       "Friday"
      List<Widget> subjects(int num) {
        List<Widget> list = [];
        int kosy = num + 1;
        list.add(Container(
            height: height,
            child: Center(
                child: Text(
                  "$kosy",
                  textAlign: TextAlign.center,
                  style: textStyle,
                ))));
        list.add(Center(
            child: Text(
              MMMap["Monday"][num],
              textAlign: TextAlign.center,
              style: textStyle,
            )));
        list.add(Center(
            child: Text(
              MMMap["Tuesday"][num],
              textAlign: TextAlign.center,
              style: textStyle,
            )));
        list.add(Center(
            child: Text(
              MMMap["Wednesday"][num],
              textAlign: TextAlign.center,
              style: textStyle,
            )));
        list.add(Center(
            child: Text(
              MMMap["Thursday"][num],
              textAlign: TextAlign.center,
              style: textStyle,
            )));
        list.add(Center(
            child: Text(
              MMMap["Friday"][num],
              textAlign: TextAlign.center,
              style: textStyle,
            )));
        return list;
      }

      List<TableRow> list = [];
      list.add(TableRow(children: [...weekends()]));
      for (int i = 0; i <= 6; i++) {
        list.add(TableRow(children: [...subjects(i)]));
      }
      return list;
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
      },
      children: [...tableRows()],
    );
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
    return Padding(padding: EdgeInsets.all(12.0), child: table);
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
