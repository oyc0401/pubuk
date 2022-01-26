import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/Community/write.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';

class edit extends StatefulWidget {
  edit({Key? key, required this.url}) : super(key: key);
  String url = 'cc'; //  부모의 ID
  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  String text = '';
  String id = '';
  String nickname = '';

  getProfile() async {
    SaveKey key = await SaveKey().getInstance();
    id = key.uid();
    nickname = key.nickname();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    loadText();
  }



  Widget fil = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('수정'),
        actions: [
          IconButton(
            onPressed: () {
              if (text != '') {
                updateText().then((value) {
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
            fil,
            Container(
              height: 500,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Future loadText() async {
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .get()
        .then((doc) {
      setState(() {
        fil = TextFormField(
          onChanged: (text) {
            this.text = text;
          },
          keyboardType: TextInputType.multiline,
          initialValue: doc['text'],
          minLines: 4,
          maxLines: null,
          decoration: const InputDecoration(
              hintText: "내용을 입력하세요.", border: InputBorder.none),
        );
      });
    });
  }

  Future updateText() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";

    FirebaseFirestore.instance.collection('pubuk').doc(widget.url).update({
      'text': text,
      'title': '',
    }).then((value) {
      print("User Added");
    }).catchError((error) => print("Failed to add user: $error"));
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
