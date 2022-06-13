import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/FireTool.dart';
import 'package:flutterschool/page/Profile/editProfile.dart';
import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("부천북고등학교"),
        actions: [
          IconButton(
            onPressed: NavigateProfile,
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: ListView(
        children: [
          TimeTableSection(),
          LunchSection(),
          UserWidget(),
          CupertinoButton(
            onPressed: () {
              UserProfile user = UserProfile.currentUser;
              print(user.toMap());
            },
            child: const Text('저장소 확인'),
          ),
          const SizedBox(height: 30),
          Container(
            height: 400,
          ),
        ],
      ),
    );
  }

  Widget TimeTableSection() {
    // MyTimeTable 에 const 붙히면 정보가 바뀌어도 재시작 안함
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MyTimeTable(),
    );
  }

  Widget LunchSection() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: LunchBuilder(),
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

  Future<void> checkKey() async {
    UserProfile userProfile = UserProfile.currentUser;
    print(userProfile);
  }
}

class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

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

  setServerDB() async {
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

  setGoogle() async {
    if (userProfile.provider == "Google") {
      GoogleLogin googleLogin = GoogleLogin();
      googleKakao = googleLogin.getCurrentUser();
      loginColor = Colors.indigo;
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      googleKakao = await kakaoLogin.getCurrentUser();
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
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            LocalIsServer,
            style: TextStyle(color: titleColor),
          ),
          SizedBox(height: 20),
          Text(
            'User profile: ${userProfile.toString()}',
            style: TextStyle(color: profileColor),
          ),
          SizedBox(height: 20),
          Text(
            'Server profile: ${serverProfile.toString()}',
            style: TextStyle(color: serverColor),
          ),
          SizedBox(height: 20),
          Text(
            "Local firebase user: ${user.toString()}",
            style: TextStyle(color: localColor),
          ),
          SizedBox(height: 20),
          Text(
            "Login information: $googleKakao",
            style: TextStyle(color: loginColor),
          ),
        ],
      ),
    );
  }
}
