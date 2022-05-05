import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/GetFirebase.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../DB/saveKey.dart';
import 'setting.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  /// 로딩전 초기값
  Widget loadingCircle = Container();

  /// 로딩전 초기값



  Future _addUser() async {
    //파이어베이스에 유저정보 저장
    //기존 정보가 없으면 초기화 시켜줌
    FirebaseAuth auth = FirebaseAuth.instance;

    //정보 얻어오기
    String? uid = auth.currentUser?.uid ?? '로그인 해주세요';
    String? email = auth.currentUser?.email ?? '이메일이 없습니다.';
    String? displayName = auth.currentUser?.displayName ?? '이름이 없습니다.';
    String? photoURL = auth.currentUser?.photoURL ?? '사진이 없습니다.';

    SaveKey key = await SaveKey.Instance();
    // id가 저장되어있는지 체크

    ///TODO: 서버호출의 중복이 일어나서 나중에 고쳐야한다.
    GetFirebase.isUserExist(uid).then((isUserExist) async {
      print(isUserExist);
      if (isUserExist) {
        print('기존 로그인');
        await GetFirebase.getUser(uid).then((map) {
          key.setUser(map['ID'], map['nickname'], map['auth'], map['grade'],
              map['class'],7530072);
          Navigator.of(context).pop(true);
        });
      } else {
        print('신규 가입');
        await GetFirebase.newSignIn(uid, email, displayName, photoURL);
        key.setUser(uid, displayName, 'user', 1, 1,7530072);
        Navigator.of(context).pop(true);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => setting()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              CupertinoButton(
                  onPressed: () {
                  },
                  color: Colors.grey,
                  child: const Text(
                    '구글 로그인',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )),
              const SizedBox(
                height: 50,
              ),
              loadingCircle
            ],
          ),
        ),
      ),
    );
  }

  Future<String> LocalTime() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";
    return date;
  }
}
