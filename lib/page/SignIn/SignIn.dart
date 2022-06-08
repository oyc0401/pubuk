import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/Server/FireTool.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Home/home.dart';
import '../mainPage.dart';
import 'register.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId 개새끼..

  scopes: <String>[
    'email',
  ],
);



class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();

    /// 테스트기간에만 주석 해놓는것이다. 이 페이지에 들어오면 무조건 로그인 해제 상태여야 한다.
    _handleSignOut();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      print("로그인 정보가 변화하면 이게 울림");
    });
    _googleSignIn.signInSilently();
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // print(userCredential.additionalUserInfo);
      // print(userCredential.credential);
      // print(userCredential.user);
      navigate();
    } catch (error) {
      print(error);
    }
  }

  Future signInWithApple() async {}

  Future signInWithKaKao() async {
    try {
      await kakao.UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }

    // try {
    //   await kakao.UserApi.instance.unlink();
    //   print('연결 끊기 성공, SDK에서 토큰 삭제');
    // } catch (error) {
    //   print('연결 끊기 실패 $error');
    // }


    if (await kakao.isKakaoTalkInstalled()) {
      try {
        await kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공1');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공2');

        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공3');

        try {
          kakao.User user = await kakao.UserApi.instance.me();
          print('사용자 정보 요청 성공'
              '\n회원번호: ${user.id}'
              '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
              '\n이메일: ${user.kakaoAccount?.email}');
        } catch (error) {
          print('사용자 정보 요청 실패 $error');
        }

      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void navigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("이동중..");

    if (user != null) {
      FireUser fireUser = FireUser(uid: user.uid);
      await fireUser.checkRegister(
          onNotExist: NavigeteRegister, onExist: NavigateHome);
    } else {
      print("이게 왜?");
    }
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
              googleLoginButton(),
              SizedBox(
                height: 20,
              ),
              appleLoginButton(),
              SizedBox(
                height: 20,
              ),
              kakaoLoginButton()
            ],
          ),
        ),
      ),
    );
  }

  InkWell googleLoginButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in with Google",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      onTap: () {
        print("google Login touch");
        signInWithGoogle();
      },
    );
  }

  Widget appleLoginButton() {
    return SignInWithAppleButton(
      onPressed: () async {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        print(credential);

        // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
        // after they have been validated with Apple (see `Integration` section for more information on how to do this)
      },
    );
  }

  InkWell kakaoLoginButton() {
    return InkWell(
      onTap: signInWithKaKao,
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xffFEE500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in with KaKao",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
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
