// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterschool/page/Profile/accountInfo.dart';
import 'package:flutterschool/page/Profile/editProfile.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';

import '../../DB/userProfile.dart';
import '../../MyWidget/button.dart';
import '../Univ/WebViewSetting.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  UserSchool userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '프로필',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "내 정보",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: goSetting(),
          ),
          //Logined(),
          // webviewSetting(),
        ],
      ),
    );
  }

  Widget goSetting() {
    return InkWell(
      onTap: navigateSetting,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Color(0xffe1e1e1),
          child: ListTile(
            title: Text(userProfile.name),
            subtitle: Text("${userProfile.grade}학년 ${userProfile.Class}반 "),
          )),
    );
  }

  // Widget Logined() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user == null) {
  //     return InkWell(
  //       onTap: navigateSignIn,
  //       child: Card(
  //         margin: EdgeInsets.all(12),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         color: Colors.grey,
  //         child: Container(
  //           height: 50,
  //           child: Center(
  //             child: Text(
  //               '로그인',
  //               style: TextStyle(fontSize: 18, color: Colors.black),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return Column(
  //     children: [
  //       CupertinoButton(
  //         child: Text(
  //           '로그인 정보',
  //           style: TextStyle(fontSize: 18, color: Colors.black),
  //         ),
  //         color: Colors.grey,
  //         onPressed: navigateAccountInfo,
  //       ),
  //     ],
  //   );
  // }

  // Widget webviewSetting() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20),
  //     child: RoundButton(
  //       onclick: navigateWebviewSetting,
  //       text: "웹뷰설정",
  //       color: Colors.lightBlueAccent,
  //     ),
  //   );
  // }

  // void navigateAccountInfo() {
  //   Navigator.push(
  //     context,
  //     CupertinoPageRoute(builder: (context) => const AccountInfo()),
  //   );
  // }

  // void navigateSignIn() async {
  //   await Navigator.push(
  //     context,
  //     CupertinoPageRoute(builder: (context) => const SignIn()),
  //   );
  // }

  void navigateSetting() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const EditProfile()),
    );

    setState(() {});
  }
}
