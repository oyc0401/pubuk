import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterschool/page/Profile/accountInfo.dart';
import 'package:flutterschool/page/Profile/editProfile.dart';
import 'package:flutterschool/page/SignIn/SignIn.dart';

import '../../DB/userProfile.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  UserProfile userProfile = UserProfile();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  Future<UserProfile> getProfile() async {
    return await UserProfile.Get();
  }

  User? getUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return waiting();
              } else if (snapshot.hasError) {
                return error(snapshot);
              } else {
                return myprofileSection(snapshot);
              }
            },
            future: getProfile(),
          ),
        ],
      ),
    );
  }

  Widget error(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Error: ${snapshot.error}',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget waiting() {
    return const SizedBox(
      height: 340,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget myprofileSection(AsyncSnapshot<dynamic> snapshot) {
    UserProfile userProfile = snapshot.data;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return InkWell(
        child: Container(
          child: Text('로그인'),
          height: 100,
          color: Colors.grey,
        ),
        onTap: navigateSignIn,
      );
    }

    String uid = user.uid;

    print(user.toString());

    return Column(
      children: [
        CupertinoButton(
          child: Text('로그인 정보'),
          onPressed: navigateAccountInfo,
        ),
        InkWell(
          child: Container(
            height: 100,
            color: Colors.grey,
            child: Column(
              children: [
                Text(userProfile.nickname),
                Text(uid),
              ],
            ),
          ),
          onTap: navigateSetting,
        ),
      ],
    );
  }

  void navigateAccountInfo() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const AccountInfo()),
    );
  }

  void navigateSignIn() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const SignIn()),
    );
  }

  void navigateSetting() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const setting()),
    );
  }
}
