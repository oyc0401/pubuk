import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class myprofile extends StatefulWidget {
  const myprofile({Key? key}) : super(key: key);

  @override
  _myprofileState createState() => _myprofileState();
}

class _myprofileState extends State<myprofile> {
  int Grade = 1;
  int Class = 1;
  String nickname='';
  String id='1';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("닉네임:"),
                TextButton(
                    onPressed: () {
                      //showClassDialog(context);
                    },
                    child: Text("$nickname")),
              ],
            ),
            Row(
              children: [
                Text("학년:"),
                TextButton(
                    onPressed: () {
                      showGradeDialog(context);
                    },
                    child: Text("$Grade학년")),
              ],
            ),
            Row(
              children: [
                Text("반:"),
                TextButton(
                    onPressed: () {
                      showClassDialog(context);
                    },
                    child: Text("$Class반"))
              ],
            ),
            CupertinoButton(
                child: Text('로그아웃'),
                onPressed: () {
                  _Logout();
                }),
            CupertinoButton(
                child: Text('회원 탈퇴'),
                onPressed: () {

                  Delete();
                  Navigator.of(context).pop(true);
                })
          ],
        ),
      ),
    );
  }

  Future Delete() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }

    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));

  }

  _loadProfile() async {
    id = FirebaseAuth.instance.currentUser?.uid ?? '게스트 모드';
    print("ID: $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('Nickname') ?? '게스트';
      Grade = prefs.getInt('Grade') ?? 1;
      Class = prefs.getInt('Class') ?? 1;
      print("$Grade학년");
      print("$Class반");
    });
  }

  Future _Logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID', '게스트');
    prefs.setString('Nickname', '게스트');
    Navigator.of(context).pop(true);
  }

  _setGrade(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Grade', num);
    });
    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update({'grade': num}).then((value) async {
      print('Grade Update');
    }).catchError((error) => print("Failed to change Grade: $error"));
  }

  _setClass(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Class', num);
    });
    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update({'class': num}).then((value) async {
      print('Class Update');
    }).catchError((error) => print("Failed to change Class: $error"));
  }

  showClassDialog(BuildContext context) {
    SelectDialog.showModal<String>(
      context,
      label: "반을 선택하세요",
      selectedValue: "$Class반",
      items: List.generate(9, (index) {
        var num = index + 1;
        return "$num반";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          Class = int.parse(dd[0]);
          _setClass(Class);
        });
      },
      showSearchBox: false,
    );
  }

  showGradeDialog(BuildContext context) {
    SelectDialog.showModal<String>(
      context,
      label: "학년을 선택하세요",
      selectedValue: "$Grade학년",
      items: List.generate(3, (index) {
        var num = index + 1;
        return "$num학년";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          Grade = int.parse(dd[0]);
          _setGrade(Grade);
        });
      },
      showSearchBox: false,
    );
  }


}
