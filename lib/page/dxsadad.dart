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

class community33 extends StatefulWidget {
  const community33({Key? key}) : super(key: key);

  @override
  _community33State createState() => _community33State();
}

//

class _community33State extends State<community33> {
  @override
  void initState() {
    super.initState();
    read();
  }

  var text = '오류발생';

  CollectionReference pubuk = FirebaseFirestore.instance.collection('pubuk');

  Future read() async {
    pubuk.doc('2022-01-14 17:42:44.088676').get().then((value) {
      // print(value.data());
      setState(() {
        text = value.data().toString();
      });
    });
  }

  Future readall() async {
    pubuk.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['date']);
      });
    });
  }


  Future readPage() async {
    pubuk.limit(4).get().then((QuerySnapshot querySnapshot) {
      print("나나");
      querySnapshot.docs.forEach((doc) {
        print(doc['date']);
        abc.add(doc['date']);
      });
    });
  }
  List abc=[];
  Future<void> deleteUser() {
    return pubuk
        .doc('2022-01-14 14:11:23.2334')
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
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
      body: FutureBuilder(
          future: readPage(),
          builder: (context,snapshot) {
            return RefreshIndicator(
              child: ListView(
                children: [
                  CupertinoButton(
                      child: Text('eqw3d'),
                      onPressed: () {
                        print(abc);
                      }),
                  ...sdas()
                ],
              ),
              onRefresh: read,
            );
          }
      ),
    );
  }
  List sdas<Widget>(){
    List dd=[];
    dd.add(Text(abc[0]));
    return dd;
  }
}

