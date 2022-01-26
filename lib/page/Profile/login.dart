import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Widget loadingCircle = Container();

  Future _GoogleLogin(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth?.accessToken != null || googleAuth?.idToken != null) {
      //로딩 표시
      setState(() {
        loadingCircle = const SizedBox(
            height: 200, child: Center(child: CircularProgressIndicator()));
      });

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _addUser();
    } else {
      print('로그인 취소');
    }
  }

  Future _addUser() async {
    //파이어베이스에 유저정보 저장
    //기존 정보가 없으면 초기화 시켜줌
    String date = await LocalTime();
    FirebaseAuth auth = FirebaseAuth.instance;

    //정보 얻어오기
    String? id = auth.currentUser?.uid ?? '로그인 해주세요';
    String? email = auth.currentUser?.email ?? '이메일이 없습니다.';
    String? displayName = auth.currentUser?.displayName ?? '이름이 없습니다.';
    String? photoURL = auth.currentUser?.photoURL ?? '사진이 없습니다.';

    SaveKey key = await SaveKey().getInstance();
    // id가 저장되어있는지 체크
    await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((value) {
      //신규 가입일 때
      if (value.data() == null) {
        print('신규 가입');
        FirebaseFirestore.instance.collection('user').doc(id).set({
          'ID': id,
          'userid': id,
          'email': email,
          'nickname': displayName,
          'displayName': displayName,
          'photoURL': photoURL,
          'signupDate': date,
          'grade': 1,
          'class': 1,
          'auth': 'user'
        }).then((value) {
          key.SetUser(id,displayName,'user',1,1);
          print("User Sign up");
        }).catchError((error) {
          print("Failed to Sign up: $error");
        });
        Navigator.of(context).pop(true);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => setting()));

        //기존 로그인
      } else {
        print('기존 로그인');
        key.SetUser(value['ID'], value['nickname'], value['auth'],
            value['grade'], value['class']);
        Navigator.of(context).pop(true);
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
                    _GoogleLogin(context);
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
