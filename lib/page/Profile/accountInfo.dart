import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';
import 'package:flutterschool/page/mainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../DB/userProfile.dart';
import '../../Server/FireTool.dart';
import '../Home/home.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          AccountWidget(),
        ],
      ),
    );
  }

  Widget AccountWidget() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Text("Dsa");
    }

    return Card(
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(user.photoURL ??
                  "https://dfge.de/wp-content/uploads/blank-profile-picture-973460_640.png"),
            ),
            title: Text(
              user.email ?? "23",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            subtitle: Text(
              "uid: ${user.uid}",
            ),
          ),
          CupertinoButton(
            child: Text(
              "로그아웃",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: _onTapLogoutButton,
          ),
          CupertinoButton(
            child: Text(
              "회원 탈퇴",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: _onTapDeleteButton,
          ),
        ],
      ),
    );
  }

  Logout() async {
    UserProfile userProfile = UserProfile.currentUser;
    if (userProfile.provider == "Google") {
      GoogleLogin googleLogin = GoogleLogin();
      await googleLogin.logout();
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      kakaoLogin.logout();
    }

    FirebaseAuth.instance.signOut();
    UserProfileHandler.SwitchGuest();
    navigateHome();
  }

  Future<void> deleteUser() async {
    UserProfile userProfile = UserProfile.currentUser;
    FireUser fireUser = FireUser(uid: userProfile.uid);
    await fireUser.deleteUser();

    if (userProfile.provider == "Google") {
      GoogleLogin googleLogin = GoogleLogin();
      if( await googleLogin.deleteUser()==true){
        UserProfileHandler.SwitchGuest();
        navigateHome();
      }else{
        print("회원탈퇴가 안되었습니다.");
      }
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      if(await kakaoLogin.deleteUser()==true){
        UserProfileHandler.SwitchGuest();
        navigateHome();
      }else{
        print("회원탈퇴가 안되었습니다.");
      }

    }


  }

  void _onTapDeleteButton() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Text("회원 탈퇴"),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "계정을 삭제 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("네"),
                onPressed: deleteUser,
              ),
            ],
          );
        });
  }

  void _onTapLogoutButton() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Text("로그아웃"),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "로그아웃 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("네"),
                onPressed: Logout,
              ),
            ],
          );
        });
  }

  void navigateHome() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(),
        ),
        (route) => false);
  }
}
