import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/findschool.dart';
import 'package:flutterschool/MyWidget/button.dart';

import 'package:select_dialog/select_dialog.dart';

import '../../DB/userProfile.dart';
import '../../Server/FireTool.dart';
import '../mainPage.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  /// 닉네임, 학년, 반을 바꾸면 [userData] 내부 값을 변화시킨다.
  /// 저장 버튼을 누르면 [userData]에 있는 값을 저장하고 화면을 종료한다.
  /// 로그인 상태라면 파이어베이스에도 저장한다.

  UserProfile userData = UserProfile.currentUser;

  Future<void> Save(UserProfile myUserData) async {
    // 로컬 DB에 저장
    UserProfile.save(myUserData);

    switch (userData.provider) {
      case "Google":
      case "Apple":
      case "Kakao":
        // firebase DB에 저장
        print("현재 로그인 상태입니다.");
        FireUser fireUser = FireUser(uid: myUserData.uid);
        fireUser.updateGrade(
          grade: myUserData.grade,
          Class: myUserData.Class,
        );
        break;
    }

    // 나가기
    Navigator.of(context).pop('complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '정보 수정',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            schoolSection(),
            SizedBox(
              height: 40,
            ),
            gradeSection(),
            SizedBox(
              height: 15,
            ),
            classSection()
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RoundButton(
        onclick: () {
          Save(userData);
        },
        text: '저장',
        color: Color(0xffFFEC83),
        fontSize: 20,
      ),
    );
  }



  Widget schoolSection() {
    return RoundButton(
      text: userData.schoolName,
      onclick: NavigateFindSchool,
      color: Color(0xffb4d5ff),
    );
  }

  Widget gradeSection() {
    int myGrade = userData.grade;
    return RoundButton(
      text: "$myGrade학년",
      onclick: changeGrade,
      color: Color(0xffeeeeee),
    );
  }

  Widget classSection() {
    int myClass = userData.Class;
    return RoundButton(
      text: "$myClass반",
      onclick: changeClass,
      color: Color(0xffeeeeee),
    );
  }

  Future<void> changeGrade() async {
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
            print(selected);
            var dd = selected.split('');
            initGrade = int.parse(dd[0]);
          });
        },
        showSearchBox: false,
      );

      return initGrade;
    }

    int Grade = await getGradeDialog(context, userData.grade);
    userData.grade = (Grade);
    setState(() {});
  }

  Future<void> changeClass() async {
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
          print(selected);
          var dd = selected.split('');
          initClass = int.parse(dd[0]);
        },
        showSearchBox: false,
      );
      return initClass;
    }

    int Class = await getClassDialog(context, userData.Class);
    userData.Class = (Class);
    setState(() {});
  }

  void NavigateFindSchool() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const findSchool(),
      ),
    );
  }
}
