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
  const community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  List TEXTLIST = [];
  String finalDate = '2022-01-15 00:09:27.614909';
  String firstDate = '';
  List<Widget> widgetList = [
    const SizedBox(
        height: 200, child: Center(child: CircularProgressIndicator()))
  ];

  Future getfirstDate() async {
    //reset All DATA
    TEXTLIST = [];
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
      TEXTLIST.add(firstvalue);
    });
    finalDate = firstDate;
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
            TEXTLIST.add(doc['date']);
            finalDate = doc['date'];
          });
        });
    print(TEXTLIST);

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
    int lenght = TEXTLIST.length;

    for (int i = 0; i < lenght; i++) {
      Widget baby=Text(TEXTLIST[i]);


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
                  print(TEXTLIST);
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
