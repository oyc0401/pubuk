import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Home/home.dart';
import 'package:flutterschool/page/Profile/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SignIn/register.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId:
      '38235317642-4i8ul6m33g6ljpap0bk2b46lv05k1j79.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SwitchPage extends StatefulWidget {
  const SwitchPage({Key? key}) : super(key: key);

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      //_currentUser = account;

      // if (account == null) {
      //   print("유저는 현재 비 로그인 상태이다.");
      //
      //   navigateLogin();
      // } else {
      //   print(account.toString());
      //   navigateLogin();
      // }
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
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
    } else {}

    //       Navigator.pushReplacement(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const MyHomePage(title: "학교"),
    //     ),
    //   );
  }

  void navigateLogin() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const login(),
      ),
    );
  }

  void navigateRegister() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const register(),
      ),
    );
  }

  void navigateHome() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const MyHomePage(title: "title"),
      ),
    );
  }
}
