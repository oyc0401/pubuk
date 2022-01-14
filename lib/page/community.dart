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

//

class _communityState extends State<community> {
  CollectionReference pubuk = FirebaseFirestore.instance.collection('pubuk');
  int where = 0;
  List TEXTLIST = [];

  List ALLDATE = [];

  Future refresh() async {
    setState(() {});
  }

  Future readPage() async {
    print('readPage');
    TEXTLIST = [];
    where = 4;
    await pubuk
        .orderBy('date', descending: true)
        .limit(4)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['date']);
        TEXTLIST.add(doc['date']);
      });
    });
  }

  Future readall() async {
    print('readall');
    ALLDATE = [];
    await pubuk
        .orderBy('date', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ALLDATE.add(doc['date']);
      });
      print(ALLDATE.toString());
    });
    await readPage();
    widgetList = widget_List();
  }

  Future readMore() async {
    print('더 읽어유');
    pubuk.limit(4).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['date']);
        TEXTLIST.add(doc['date']);
      });
    });
  }

  List<Widget> widget_List() {
    print("what?");
    List<Widget> dd = [];
    dd.add(Text(TEXTLIST.toString()));
    dd.add(Text(TEXTLIST[0]));
    dd.add(Text(TEXTLIST[1]));
    dd.add(Text(TEXTLIST[2]));
    dd.add(Text(TEXTLIST[3]));
    return dd;
  }

  List<Widget> widgetList = [];

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
      body: FutureBuilder(
          future: readall(),
          builder: (context, snapshot) {
            return RefreshIndicator(
              child: ListView(
                children: [
                  CupertinoButton(
                      child: Text('추가버튼'),
                      onPressed: () {
                        print(TEXTLIST);
                      }),
                  CupertinoButton(
                      child: Text('setstate'),
                      onPressed: () {
                        setState(() {});
                      }),
                  ...widgetList
                ],
              ),
              onRefresh: refresh,
            );
          }),
    );
  }
}
