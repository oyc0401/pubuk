import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterschool/Server/FirebaseAirPort.dart';

import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';

import '../../DB/userProfile.dart';


class UserWidget extends StatefulWidget {
  UserWidget({Key? key}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  UserProfile userProfile = UserProfile.currentUser;
  UserProfile? serverProfile;

  User? user = FirebaseAuth.instance.currentUser;
  String LocalIsServer = '게스트 모드';
  String googleKakao = "";

  Color titleColor = Colors.black;
  Color profileColor = Colors.black;
  Color serverColor = Colors.black;
  Color localColor = Colors.black;
  Color loginColor = Colors.black;

  @override
  initState() {
    super.initState();
    setServerDB();
    setGoogle();
  }

  void setServerDB() async {
    FirebaseAirPort fireUser = FirebaseAirPort(uid: userProfile.uid);
    if (userProfile.provider == "") {
      return;
    }
    serverProfile = await fireUser.get();
    serverColor = Colors.indigo;
    if (userProfile.toString() == serverProfile.toString()) {
      LocalIsServer = "휴대폰 정보가 현재 서버정보와 같습니다. O";
    } else {
      LocalIsServer = "X 휴대폰 정보가 현재 서버정보와 다릅니다. X";
      titleColor = Colors.redAccent;
      profileColor = Colors.redAccent;
    }
    setState(() {});
    assert(userProfile.toString() == serverProfile.toString(),
    "오류: 서버 정보와 현재 휴대폰 정보와 같지 않습니다.");
  }

  void setGoogle() async {
    if (userProfile.provider == "Google") {
      GoogleLogin googleLogin = GoogleLogin();
      googleKakao = googleLogin.getCurrentUser();
      loginColor = Colors.indigo;
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      googleKakao =
      "${(await kakaoLogin.getCurrentUser()).toString()}\n${await kakaoLogin.getTime()}";
      loginColor = Colors.indigo;
    } else if (userProfile.provider == "") {
      googleKakao = "소셜 로그인 상태가 아닙니다.";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            LocalIsServer,
            style: TextStyle(color: titleColor),
          ),
          const SizedBox(height: 20),
          Text(
            'User profile: ${userProfile.toString()}',
            style: TextStyle(color: profileColor),
          ),
          const SizedBox(height: 20),
          Text(
            'Server profile: ${serverProfile.toString()}',
            style: TextStyle(color: serverColor),
          ),
          const SizedBox(height: 20),
          Text(
            "Local firebase user: ${user.toString()}",
            style: TextStyle(color: localColor),
          ),
          const SizedBox(height: 20),
          Text(
            "Login information: $googleKakao",
            style: TextStyle(color: loginColor),
          ),
        ],
      ),
    );
  }
}
