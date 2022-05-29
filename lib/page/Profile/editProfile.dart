import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/findschool.dart';

import 'package:select_dialog/select_dialog.dart';

import '../../DB/userProfile.dart';


class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  /// [getUserData]에서 [UserProfile]를 불러온다.
  /// [isfirst]가 true면 [userData]에 집어넣고 [isfirst]를 false로 바꾼다.
  /// [userData]는 중요한 역할을 하고있다.
  /// 닉네임, 학년, 반을 바꾸면 이 내부 값을 변화시킨다.
  /// 저장 버튼을 누르면 [userData]에 있는 값을 [saveKey]에 저장하고 화면을 종료한다.
  /// 나중에 로그인을 구현한다면 저장을 할 때 파이어베이스의 유저정보도 함께 바꿔야 한다.

  UserProfile userData = UserProfile.currentUser;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    print("setstate!");
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            schoolSection(),
            gradeSection(),
            classSection(),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('정보 수정'),
      actions: [
        TextButton(
            onPressed: () {
              Save(userData);
            },
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      ],
    );
  }

  Widget schoolSection() {
    return CupertinoButton(
      child: Text("${userData.schoolName}"),
      onPressed: NavigateFindSchool,
    );
  }
  Widget gradeSection() {
    int myGrade = userData.grade;

    return Row(
      children: [
        const Text("학년:"),
        TextButton(onPressed: changeGrade, child: Text("$myGrade학년")),
      ],
    );
  }

  Widget classSection() {
    int myClass = userData.Class;

    return Row(
      children: [
        const Text("반:"),
        TextButton(onPressed: changeClass, child: Text("$myClass반"))
      ],
    );
  }


  Future<void> Save(UserProfile myUserData) async {
    await UserProfile.Save(myUserData);

    // FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(myUserData.getUid())
    //     .update({
    //   'grade': myUserData.getGrade(),
    //   'class': myUserData.getClass(),
    //   'nickname': myUserData.getNickName()
    // }).then((value) async {
    //   print('Class Update');
    // }).catchError((error) => print("Failed to change Class: $error"));

    Navigator.of(context).pop('complete');
  }

  void NavigateFindSchool() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const findSchool(),
      ),
    );
  }

  Future<void> changeGrade() async {
    int Grade = await getGradeDialog(context, userData.grade);
    userData.grade=(Grade);
    setState(() {});
  }

  Future<void> changeClass() async {
    int Class = await getClassDialog(context, userData.Class);
    userData.Class=(Class);
    setState(() {});
  }

  Future<int> getGradeDialog(BuildContext context, int initGrade) async {
    await SelectDialog.showModal<String>(
      context,
      label: "학년을 선택하세요",
      selectedValue: "$initGrade학년",
      items: List.generate(3, (index) {
        var num = index + 1;
        return "$num학년";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          initGrade = int.parse(dd[0]);
        });
      },
      showSearchBox: false,
    );

    return initGrade;
  }

  Future<int> getClassDialog(BuildContext context, int initClass) async {
    await SelectDialog.showModal<String>(
      context,
      label: "반을 선택하세요",
      selectedValue: "$initClass반",
      items: List.generate(9, (index) {
        var num = index + 1;
        return "$num반";
      }),
      onChange: (String selected) {
        var dd = selected.split('');
        initClass = int.parse(dd[0]);
      },
      showSearchBox: false,
    );
    return initClass;
  }

}
