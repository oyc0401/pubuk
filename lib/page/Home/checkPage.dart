import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/setting.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../../DB/userProfile.dart';

import '../../DB/saveKey.dart';
import '../Community/community.dart';
import '../Profile/myinfo.dart';
import '../SignIn/SignIn.dart';


class checkPage extends StatefulWidget {
  const checkPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<checkPage> createState() => _checkPageState();
}

class _checkPageState extends State<checkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          onPressed: NavigateSetting,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  ListView body() {
    return ListView(
      children: [
        CommunitySection(),
        CupertinoButton(
            child: const Text('저장소 확인'),
            onPressed: () {
              checkKey();
            }),
        CupertinoButton(child: Text("로그인 페이지 이동"), onPressed: NavigateSignup),
        const SizedBox(height: 30),
        Container(
          height: 400,
          color: Colors.grey,
        )
      ],
    );
  }

  void NavigateSignup() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignIn(),
      ),
    );

    setState(() {});
  }
  Widget CommunitySection() {
    return CupertinoButton(
      child: const Text('게시판 이동'),
      onPressed: NavigateCommunity,
    );
  }


  void NavigateInfo() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const myinfo(),
      ),
    );

    setState(() {});
  }

  void NavigateSetting() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const setting(),
      ),
    );

    setState(() {});
  }

  void NavigateCommunity() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => community(),
      ),
    );
  }

  Future<void> checkKey() async {
    SaveKeyHandler key = await SaveKeyHandler.Instance();
    key.printAll();
  }
}
