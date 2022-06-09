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

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future signInWithGoogle() async {
    GoogleLogin googleLogin = GoogleLogin();
    await googleLogin.login();
    String? recivedUid=googleLogin.uid;

    if (recivedUid != null) {
      print("uid: ${recivedUid}");
      navigate(recivedUid);
    }else{
      print("로그인 실패");
    }
  }

  Future signInWithApple() async {
    AppleLogin appleLogin = AppleLogin();
    await appleLogin.login();
  }

  Future signInWithKaKao() async {
    KakaoLogin kakaoLogin = KakaoLogin();
    await kakaoLogin.login();
    String? recivedUid= kakaoLogin.uid;

    if (recivedUid != null) {
      print("uid: ${recivedUid}");
      navigate(recivedUid);
    }else{
      print("로그인 실패");
    }
  }

  void navigate(String uid) async {
    print("${uid} 회원가입 이동중..");
    FireUser fireUser = FireUser(uid: uid);
    await fireUser.checkRegister(
        onNotExist: NavigeteRegister, onExist: NavigateHome);
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

  void NavigeteRegister() {
    print("회원가입 이동합니다.");
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const register(),
      ),
    );
  }

  void NavigateHome() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => const MyHomePage(),
      ),
      (route) => false,
    );
  }
}
