import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/FireTool.dart';

import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      body: WebView(
javascriptMode: JavascriptMode.unrestricted,
        zoomEnabled: true,
        initialUrl: //"https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&chkUnivList=0000046&sch_year=2023#con20",
         'https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?sch_year=2022&univ_cd=0000046&iem_cd=26',
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
