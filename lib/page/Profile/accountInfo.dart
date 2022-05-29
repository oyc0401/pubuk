import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';
import 'package:flutterschool/page/mainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
              )),
          Text(
            user.uid,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          CupertinoButton(child: Text("로그이웃"), onPressed: Logout),
          CupertinoButton(child: Text("회원 탈퇴"), onPressed: deleteUser),
        ],
      ),
    );
  }

  Logout() async {
    await FirebaseAuth.instance.signOut();

    navigateHome();
  }

  deleteUser() async{
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      print("삭제!");
      navigateHome();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  void navigateHome(){
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(),
        ),
            (route) => false);
  }
}
