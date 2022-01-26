import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';

import 'package:select_dialog/select_dialog.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int Grade = 0;
  int Class = 0;
  String nickname = '로딩중...';
  String id = '';

  Widget textfield = Container();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 수정'),
        actions: [
          TextButton(
              onPressed: () {
                Save();
              },
              child: Text(
                '저장',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [Text("닉네임:"), textfield],
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
                color: Colors.blue,
                onPressed: () {
                  Logout();
                }),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
                child: Text('회원 탈퇴'),
                color: Colors.blue,
                onPressed: () {
                  DeleteUser();
                  Navigator.of(context).pop(true);

                })
          ],
        ),
      ),
    );
  }

  Future _loadProfile() async {
    id = FirebaseAuth.instance.currentUser?.uid ?? '게스트 모드';
    print("ID: $id");

    SaveKey key = await SaveKey().getInstance();
    setState(() {
      nickname = key.nickname();
      Grade = key.Grade();
      Class = key.Class();
      print("$Grade학년");
      print("$Class반");

      textfield = Container(
        width: 200,
        child: TextFormField(
          onChanged: (text) {
            nickname = text;
          },
          initialValue: nickname,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      );
    });
  }

  Future Save() async {
    SaveKey key = await SaveKey().getInstance();
    key.Changeinfo(nickname, Grade, Class);

    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update({'grade': Grade, 'class': Class, 'nickname': nickname}).then(
            (value) async {
      print('Class Update');
    }).catchError((error) => print("Failed to change Class: $error"));
    Navigator.of(context).pop(true);
  }

  Future Logout() async {
    await FirebaseAuth.instance.signOut();
    SaveKey key = await SaveKey().getInstance();
    key.SwitchGuest();
    Navigator.of(context).pop(true);
  }

  Future DeleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }

    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
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
        });
      },
      showSearchBox: false,
    );
  }
}
