import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/MyWidget/button.dart';
import 'package:flutterschool/Server/FireTool.dart';
import 'package:flutterschool/page/SignIn/AppleLogin.dart';
import 'package:flutterschool/page/SignIn/KakaoLogin.dart';

import 'dart:async';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../mainPage.dart';
import 'GoogleLogin.dart';
import 'register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  /// 로그인 버튼을 누르면 로그인 창이 열리고 로그인을 하면 uid를 얻음
  /// uid가 없으면 이동하지 않는다.
  /// 서버 DB에 uid에 알맞는 유저 정보가 있으면 그 정보를 로컬 DB에 저장하고 홈 화면으로 이동한다.
  /// 서버 DB에 uid에 알맞는 유저 정보가 없으면 uid와 provider를 넘기면서 회원가입 화면으로 이동한다.

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  Future signInWithGoogle() async {
    /// 구글 로그인을 통해 uid를 얻는다.
    GoogleLogin googleLogin = GoogleLogin();
    await googleLogin.login();
    String? recivedUid = googleLogin.uid;

    /// uid를 얻는데에 성공하면 화면을 이동한다.
    if (recivedUid != null) {
      print("계정으로부터 받은 uid: ${recivedUid}");
      navigate(recivedUid,"Google");
    } else {
      print("uid가 없습니다.");
    }
  }

  Future signInWithApple() async {
    /// 애플 로그인 아직 미구현
    AppleLogin appleLogin = AppleLogin();
    await appleLogin.login();
  }

  Future signInWithKaKao() async {
    /// 카카오 로그인을 통해 uid를 얻는다.
    KakaoLogin kakaoLogin = KakaoLogin();
    await kakaoLogin.login();
    String? recivedUid = kakaoLogin.uid;

    /// uid를 얻는데에 성공하면 화면을 이동한다.
    if (recivedUid != null) {
      print("uid: ${recivedUid}");
      navigate(recivedUid,"Kakao");
    } else {
      print("로그인 실패");
    }
  }

  void navigate(String uid,String provider) async {
    /// 서버 DB에 uid에 알맞는 유저 정보가 있으면 홈화면으로 이동하고
    /// 없다면 회원가입 화면으로 이동한다.

    // 회원가입 하다가 나가도 회원가입 할 수 있게 DB에 저장 하기
    UserProfile.save(UserProfile(uid: uid, provider: provider));

    print("uid: ${uid}\n서버에 계정이 있는지 확인중... ");

    // 파이어베이스에 uid에 맞는 저장소가 있는지 확인한다.
    FireUser fireUser = FireUser(uid: uid);
    UserProfile? userProfile= await fireUser.getUserProfile();

    if (userProfile==null){
      print("서버 DB에 동일한 유저 정보가 없습니다. 회원가입 이동...");
      NavigeteRegister(uid,provider);
    }else{
      print("서버 DB에 동일한 유저 정보가 있습니다. 홈 화면 이동...");
      await UserProfile.save(userProfile);
      NavigateHome();
    }

  }

  void NavigeteRegister(String uid,String provider) {
    print("회원가입 화면 이동합니다.");
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => register(uid: uid,provider: provider),
      ),
          (route) => false,
    );
  }

  void NavigateHome() {
    print("홈 화면 이동합니다.");
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const MyHomePage(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff99765F),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 170,
              ),
              Text(
                "Title",
                style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300,
              ),
              loginButtonSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButtonSection() {
    return Column(
      children: [
        RoundButton(
          onclick: signInWithGoogle,
          text: "Sign in with Google",
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SignInWithAppleButton(
            onPressed: signInWithApple,
          ),
        ),
        RoundButton(
          onclick: signInWithKaKao,
          text: "Sign in with KaKao",
          color: const Color(0xffFEE500),
        ),
      ],
    );
  }
}
