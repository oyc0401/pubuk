import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/edit.dart';
import 'package:flutterschool/page/view.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class community extends StatefulWidget {
  community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  List docNameList = [];
  List MAPLIST = [];
  String finalDate = '2022-01-15 00:09:27.614909';
  String firstDate = '';
  List<Widget> widgetList = [
    const SizedBox(
        height: 200, child: Center(child: CircularProgressIndicator()))
  ];

  Future getfirstDate() async {
    //reset All DATA
    docNameList = [];
    widgetList = [];

    //get firstDate;
    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print('처음값은');
      String firstvalue = querySnapshot.docs[0]['date'];
      print(firstvalue);
      firstDate = firstvalue;
      docNameList.add(firstvalue);

      MAPLIST=[docToMap(doc: querySnapshot.docs[0]).recivedMap()];

      finalDate = firstDate;
    });
  }

  Future readPage() async {
    print('readPage');

    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .startAfter([finalDate])
        .limit(4)
        .get()
        .then((QuerySnapshot querySnapshot) {
          //print ('바로밑');
          //print (querySnapshot.docs[0]['id']);

          querySnapshot.docs.forEach((doc) {
            print(doc['date']);
            docNameList.add(doc['date']);
            finalDate = doc['date'];

            MAPLIST.add(docToMap(doc: doc).recivedMap());

          });
        });
    print(docNameList);
    //print(MAPLIST);

    setState(() {
      widgetList = _WidgetList();
    });
  }

  Future reset() async {
    await getfirstDate();
    await readPage();
  }

  List<Widget> _WidgetList() {
    List<Widget> valuewidgets = [];

    print("위젯을 만들기 시작합니다!");
    int lenght = docNameList.length;

    print(MAPLIST);

    for (int i = 0; i < lenght; i++) {
      //make widget
      Widget baby = Padding(
        child: Column(
          children: [
            Text(MAPLIST[i]['id']),
            Text(MAPLIST[i]['nickname']),
            Text(MAPLIST[i]['text']),
            Text(MAPLIST[i]['date']),
            Text(MAPLIST[i]['image']),
          ],
        ),
        padding: EdgeInsets.all(12),
      );

      //return widget

      //Widget popo = Text(docNameList[i]); 테스트용 이름 리스트 baby를 popo로 바꿔봐요
      valuewidgets.add(baby);
    }

    return valuewidgets;
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
        title: Text('게시판'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => edit()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: ListView(
          children: [
            CupertinoButton(
                child: Text('print textlist'),
                onPressed: () {
                  print(docNameList);
                }),
            CupertinoButton(
                child: Text('getfirstDate'),
                onPressed: () {
                  getfirstDate();
                }),
            CupertinoButton(
                child: Text('readpage'),
                onPressed: () {
                  readPage();
                  //print(TEXTLIST);
                }),
            CupertinoButton(
                child: Text('setstate'),
                onPressed: () {
                  setState(() {});
                }),
            ...widgetList
          ],
        ),
        onRefresh:
            // refresh,
            reset,
      ),
    );
  }

  Future refresh() async {
    setState(() {});
  }

  Future no() async {}
}

class docToMap {
  QueryDocumentSnapshot<Object?> doc;

  docToMap({required this.doc});

  Map recivedMap() {
    String text = doc['text'];
    String id = doc['id'];
    String nickname = doc['nickname'];
    String date = doc['date'];
    String image = doc['image'];
    Map box = {
      "id": id,
      "nickname": nickname,
      "date": date,
      "text": text,
      "image": image
    };

    return box;
  }
}
