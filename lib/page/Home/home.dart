import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/FireTool.dart';

import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';

import '../../DB/userProfile.dart';
import '../Profile/profile.dart';
import 'lunch.dart';
import 'timetable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile.schoolName,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              '${userProfile.grade}학년 ${userProfile.Class}반',
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        //backgroundColor: Colors.blue,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 24,right: 8),
            child: IconButton(
              onPressed: NavigateProfile,
              icon: const Icon(
                Icons.person_outlined,
                size: 28,
                color: Color(0xff191919),

              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyTimeTable(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: LunchBuilder(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: UserWidget(),
          ),
          Container(
            height: 400,
          ),
        ],
      ),
    );
  }

  void NavigateProfile() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const profile(),
      ),
    );

    setState(() {
      print(
          "회원 정보가 바뀌었을 수도 있어서 setState 합니다. userProfile: ${UserProfile.currentUser}");
    });
  }
}

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
    FireUser fireUser = FireUser(uid: userProfile.uid);
    if (userProfile.provider == "") {
      return;
    }
    serverProfile = await fireUser.getUserProfile();
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
