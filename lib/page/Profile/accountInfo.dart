
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/SignIn/GoogleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';

import 'package:flutterschool/page/mainPage.dart';

import '../../DB/userProfile.dart';
import '../../Server/FireTool.dart';

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
        children: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: AccountWidget(),
          ),
        ],
      ),
    );
  }
}

class AccountWidget extends StatefulWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  String? email = "";
  Widget image = const Image(image: AssetImage("assets/logo/grey_logo.png"));

  Future<void> Logout() async {
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
      if (await googleLogin.deleteUser() == true) {
        UserProfileHandler.SwitchGuest();
        navigateHome();
      } else {
        print("회원탈퇴가 안되었습니다.");
      }
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      if (await kakaoLogin.deleteUser() == true) {
        UserProfileHandler.SwitchGuest();
        navigateHome();
      } else {
        print("회원탈퇴가 안되었습니다.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setEmail();
  }

  void setEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserProfile userProfile = UserProfile.currentUser;

    if (userProfile.provider == "Google") {
      email = user?.email;
      image = const Image(image: AssetImage("assets/logo/Google_logo.png"));
    } else if (userProfile.provider == "Apple") {
      email = user?.email;
      image = const Image(image: AssetImage("assets/logo/Apple_logo.png"));
    } else if (userProfile.provider == "Kakao") {
      KakaoLogin kakaoLogin = KakaoLogin();
      email = await kakaoLogin.getEmail();
      image = const Image(image: AssetImage("assets/logo/Kakao_logo.png"));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Text("계정이 없습니다.");
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: image,
            title: Text(
              email ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            subtitle: Text(
              "uid: ${user.uid}",
            ),
          ),
          CupertinoButton(
            onPressed: _onTapLogoutButton,
            child: const Text(
              "로그아웃",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          CupertinoButton(
            onPressed: _onTapDeleteButton,
            child: const Text(
              "회원 탈퇴",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
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
            title: const Text("회원 탈퇴"),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "계정을 삭제 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("네"),
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
            title: const Text("로그아웃"),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "로그아웃 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("네"),
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
