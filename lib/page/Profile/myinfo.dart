import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';

import 'login.dart';
import 'setting.dart';

class myinfo extends StatefulWidget {
  const myinfo({Key? key}) : super(key: key);

  @override
  _myinfoState createState() => _myinfoState();
}

class _myinfoState extends State<myinfo> {
  /// 로딩전 초기값
  int Grade = 1;
  int Class = 1;
  String nickname = '';

  /// 로딩전 초기값

  @override
  void initState() {
    super.initState();
    _getProfile();
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
                    CupertinoPageRoute(builder: (context) => setting()));
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
            CupertinoButton(
                onPressed: () {
                  NavigateSetting();
                },
                color: Colors.grey,
                child: const Text(
                  '정보 수정하기',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  NavigateSetting() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => setting()),
    );
    if (result == "complete") {
      showSnackBarComplete();
    }else if(result=='Logout'){
      showSnackBarLogout();
    }
  }

  void showSnackBarComplete() {
    const snackBar = SnackBar(
      content: Text('정보가 수정 되었습니다.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBarLogout() {
    const snackBar = SnackBar(
      content: Text('로그아웃 되었습니다.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



}
