import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../DB/UserData.dart';
import '../../DB/saveKey.dart';

class write extends StatefulWidget {
  const write({Key? key}) : super(key: key);

  @override
  _writeState createState() => _writeState();
}

class _writeState extends State<write> {
  /// 로딩전 초기값
  String text = '';
  UserData userData = UserData.guestData();
  /// 로딩전 초기값

  getUserData() async {
    SaveKey key = SaveKey.Instance();
    userData = key.userData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('글쓰기'),
        actions: [
          IconButton(
            onPressed: () {
              if (text != '') {
                writepubuk(
                        collection: 'pubuk',
                        id: userData.uid,
                        nickname: userData.nickname,
                        text: text,
                        title: ' ')
                    .addText()
                    .then((value) {
                  Navigator.of(context).pop(true);
                });
              } else {
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
              decoration: const InputDecoration(
                  hintText: "내용을 입력하세요.", border: InputBorder.none),
            ),
            Container(
              height: 500,
              color: Colors.grey,
            )
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

class writepubuk {
  String collection;

  String id;
  String nickname;
  String title;
  String text;

  String? auth;
  List<String>? image;
  int? heart = 0;
  int? comment = 0;

  writepubuk({
    required this.collection,
    required this.id,
    required this.nickname,
    required this.text,
    required this.title,
    this.auth,
    this.image,
  });

  Future addText() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";

    FirebaseFirestore.instance.collection(collection).doc(date).set({
      'ID': date,
      'userid': id,
      'nickname': nickname,
      'text': text,
      'title': title,
      'heart': 0,
      'commment': 0,
      'auth': auth,
      'image': image,
      'date': date,
    }).then((value) {
      print("User Added");
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
