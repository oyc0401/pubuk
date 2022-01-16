

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class edit extends StatefulWidget {
  const edit({Key? key}) : super(key: key);

  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  String text = '';

  Future _updateUser() {
    return FirebaseFirestore.instance
        .collection('pubuk')
        .doc('2022-01-14 14:11:23.2334')
        .update({'content': "이걸로 수정했어"})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              if(text!='') {
                write(
                    collection: 'pubuk',
                    id: 'oyc0401',
                    nickname: "유찬",
                    text: text,
                    title: ' ')
                    .addText()
                    .then((value) {
                  Navigator.of(context).pop(true);
                });
              }else{
                _showDialog();

              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              onChanged: (text) {
                this.text = text;
              },
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: null,
              decoration: const InputDecoration(hintText: "내용을 입력하세요.",
                border: InputBorder.none
              ),
            ),
            Container(
              height: 500,
              color: Colors.grey,)
          ],
        ),
      ),
    );
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("알림"),
          content: const Text("내용을 입력하세요."),
          actions: <Widget>[
            CupertinoButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class write {
  String collection;

  String id;
  String nickname;
  String title;
  String text;

  String? auth;
  List<String>? image;
  int? heart = 0;
  int? comment = 0;

  write({
    required this.collection,
    required this.id,
    required this.nickname,
    required this.text,
    required this.title,
    this.auth,
    this.image,
    this.heart,
    this.comment,
  });

  Future addText() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";

    FirebaseFirestore.instance.collection(collection).doc(date).set({
      'id': id,
      'nickname': nickname,
      'text': text,
      'title': title,
      'heart': heart,
      'commment': comment,
      'auth': auth,
      'image': image,
      'date': date,
    }).then((value) {
      print("User Added");
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
