import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/FireTool.dart';

import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';
import 'package:flutterschool/page/Univ/UnivWeb.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';
import '../Home/lunch.dart';
import '../Home/timetable.dart';
import '../Profile/profile.dart';

class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  UserProfile userProfile = UserProfile.currentUser;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Column(
          children: [
            CupertinoButton(child: Text("이동"), onPressed: NavigateUnivWeb),
            CupertinoButton(child: Text("얻기"), onPressed: getUiv),
            CupertinoButton(child: Text("저장"), onPressed: insertUniv),
            CupertinoButton(child: Text("삭제"), onPressed: deleteUniv),
          ],
        ));
  }

  getUiv() async {
    UnivDB univ = UnivDB();
    List<UnivInfo> li = await univ.getInfo();

    for (UnivInfo element in li) {
      print(element.toMap());
    }
  }

  insertUniv() async {
    UnivInfo univInfo =
        UnivInfo(id: "4321", univName: "가무슨 대", univCode: "123456");
    UnivDB univ = UnivDB();
    univ.insertInfo(univInfo);
  }

  deleteUniv() async {
    UnivDB univ = UnivDB();
    univ.deleteInfo("000001");
  }

  NavigateUnivWeb() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const UnivWeb(year: 2023,univCode: "0000004",),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
          padding: const EdgeInsets.only(top: 24, right: 8),
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



