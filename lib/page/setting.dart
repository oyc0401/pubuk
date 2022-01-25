import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'myprofile.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int Grade = 1;
  int Class = 1;
  String nickname = '';

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future Delete() async {
    // Prompt the user to enter their email and password
    String email = 'barry.allen@example.com';
    String password = 'SuperSecretPassword!';

// Create a credential
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future _getProfile() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      // 비로그인 시
      if (user == null) {
        print('User is currently signed out!');
        //로그인 안되어있을시 로그인 위젯으로 변환
        setState(() {
          profile = Center(
            child: CupertinoButton(
                color: Colors.grey,
                child: Text('로그인'),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => login()));
                }),
          );
        });
      } else {
        // 로그인 돼있을 시
        print('User is signed in!');

        String id = auth.currentUser?.uid ?? '게스트';
        String email = auth.currentUser?.email ?? '이메일이 없습니다.';
        String displayName = auth.currentUser?.displayName ?? '이름이 없습니다.';
        String photoURL = auth.currentUser?.photoURL ?? '사진이 없습니다.';
        String nickname = '';
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await FirebaseFirestore.instance
            .collection('user')
            .doc(id)
            .get()
            .then((value) {
          nickname = value['nickname'];
        }).catchError((error) {
          print("Failed to get nickname: $error");
        });
        //로그인 되어있을시 내정보 위젯으로 변환
        setState(() {
          profile = Container(
            height: 120,
            child: CupertinoButton(
              color: Colors.grey,
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => myprofile()));
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        email,
                        style: TextStyle(color: Colors.black),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          photoURL,
                          width: 50,
                          height: 50,
                        ),
                      )
                    ],
                  ),
                  Text(nickname),
                ],
              ),
            ),
          );
        });
      }
    });
  }

  Widget profile = Container(
    height: 120,
    child: CupertinoButton(color: Colors.grey, onPressed: () {}, child: Row()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            profile,
          ],
        ),
      ),
    );
  }
}
