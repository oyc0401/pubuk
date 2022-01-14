import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class community extends StatefulWidget {
  const community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

//

class _communityState extends State<community> {
  @override
  void initState() {
    super.initState();
    read();
  }

  var text = '오류발생';

  CollectionReference pubuk = FirebaseFirestore.instance.collection('pubuk');

  Future read() async {
    pubuk.doc('2022-01-14 14:11:23.2334').get().then((value) {
      print(value.data());
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

  Future readsome() async {
    pubuk.limit(2).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['date']);
      });
    });
  }

  Future<void> addUser() {
    String date = '2022-01-14 14:11:24.2333';
    return pubuk
        .doc(date)
        .set({
          'id': "oyc0401",
          'title': "제목",
          'content': "Hello world!",
          'image': "abc,bcd,fds,rew",
          'date': date,
          'sha256': "b7d81268fb1873fd23r"
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser() {
    return pubuk
        .doc('2022-01-14 14:11:23.2334')
        .update({'content': "이걸로 수정했어"})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

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
      ),
      body: RefreshIndicator(
        child: ListView(
          children: [
            Text(text),
            CupertinoButton(
                child: Text('읽기'),
                onPressed: () {
                  read();
                }),
            CupertinoButton(
                child: Text('쓰기'),
                onPressed: () {
                  addUser();
                }),
            CupertinoButton(
                child: Text('수정'),
                onPressed: () {
                  updateUser();
                }),
            CupertinoButton(
                child: Text('삭제'),
                onPressed: () {
                  deleteUser();
                }),
            CupertinoButton(
                child: Text('모두 읽기'),
                onPressed: () {
                  readall();
                }),
            CupertinoButton(
                child: Text('한 페이지 읽기'),
                onPressed: () {
                  readsome();
                }),
          ],
        ),
        onRefresh: read,
      ),
    );
  }
}
