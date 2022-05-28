import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';
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
          // FutureBuilder(
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData == false) {
          //       return waiting();
          //     } else if (snapshot.hasError) {
          //       return error(snapshot);
          //     } else {
          //       return myprofileSection(snapshot);
          //     }
          //   },
          //   future: getProfile(),
          // ),
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

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId:
        '38235317642-4i8ul6m33g6ljpap0bk2b46lv05k1j79.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const SignIn(),
        ),
        (route) => false);
  }

  deleteUser() {}
}
