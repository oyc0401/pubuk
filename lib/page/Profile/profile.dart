import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterschool/page/Profile/accountInfo.dart';
import 'package:flutterschool/page/Profile/editProfile.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';

import '../../DB/userProfile.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: Column(
        children: [
          goSetting(),
          Logined(),
        ],
      ),
    );
  }

  Widget goSetting(){
    return InkWell(
      onTap: navigateSetting,
      child: Card(
          margin: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white30,
          child: ListTile(
            title: Text(userProfile.schoolName),
            subtitle:
            Text("${userProfile.grade}학년 ${userProfile.Class}반 "),
          )),
    );
  }

  Widget Logined() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return InkWell(
        onTap: navigateSignIn,
        child: Card(
          margin: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.grey,
          child: Container(
            height: 50,
            child: Center(
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        CupertinoButton(
          child: Text(
            '로그인 정보',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          color: Colors.grey,
          onPressed: navigateAccountInfo,
        ),
      ],
    );
  }

  void navigateAccountInfo() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const AccountInfo()),
    );
  }

  void navigateSignIn() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const SignIn()),
    );
  }

  void navigateSetting() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const setting()),
    );
  }
}
