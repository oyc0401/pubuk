import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;

import '../Home/home.dart';
import '../mainPage.dart';
import 'register.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId 개새끼..

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

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void navigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("이동중..");

    if (user != null) {

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(user.uid)
          .get();
      Map? map = snapshot.data();

      if (snapshot.exists) {
        print("유저 정보가 있습니다.");
        print(map);

        UserProfile userProfile = UserProfile.FirebaseUser(map!);
        await UserProfile.Save(userProfile);

        NavigateHome();

      } else {
        print("유저 정보가 없습니다.");
        NavigeteRegister();
      }



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
        signInWithGoogle();
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

  void NavigeteRegister(){
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const register(),
      ),
    );
  }
  void NavigateHome(){
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
  }


}
