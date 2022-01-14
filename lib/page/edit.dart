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
  CollectionReference pubuk = FirebaseFirestore.instance.collection('pubuk');

  String text=' ';


  Future<void> addUser() async {

    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";

    return pubuk
        .doc(date)
        .set({
      'id': "oyc0401",
      'text': text,
      'image': "abc,bcd,fds,rew",
      'date': date,
      'sha256': "b7d81268fb1873fd23r"
    })
        .then((value) {
          print("User Added");
          Navigator.of(context).pop(true);
        })
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser() {
    return pubuk
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
            onPressed: addUser,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 500,
              child: SingleChildScrollView(
                child: TextField(
                  onChanged: (text) {
                    this.text = text;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: '내용을 적어주세요'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
