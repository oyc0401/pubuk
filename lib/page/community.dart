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



class _communityState extends State<community> {

  @override
  void initState() {
    super.initState();
    read();
  }
  var text = '오류발생';

  Future read()async{
    CollectionReference users = FirebaseFirestore.instance.collection('pubuk');
    users.doc('2022.01.14').get().then((value) {
      print(value.data());
      setState(() {
        text=value.data().toString();
      });
    }
    );
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
                child: Text('눌러'),
                onPressed: () {
                  read();
                }),
          ],
        ),
        onRefresh: read,
      ),
    );
  }
}
