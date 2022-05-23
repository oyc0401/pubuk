import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;

import '../Home/home.dart';
import 'register.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId:
      '38235317642-4i8ul6m33g6ljpap0bk2b46lv05k1j79.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
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

      if (account != null) {
        print(account.toString());
      }
      print("로그인?");
      navigate(account);
    });
    _googleSignIn.signInSilently();
  }

  Future GoogleLogin() async {
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

      ///
      ///
      print(userCredential.additionalUserInfo);
      print(userCredential.credential);
      print(userCredential.user);


    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
              appleLoginButton()
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
        GoogleLogin();
      },
    );
  }

  InkWell appleLoginButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in with Apple",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void navigate(GoogleSignInAccount? user) {
    if (user != null) {
      print("유저 정보가 있습니다.");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const register(),
        ),
      );
    } else {
      print("유저는 현재 비 로그인 상태이다.");
    }

    //       Navigator.pushReplacement(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const MyHomePage(title: "학교"),
    //     ),
    //   );
  }
}
