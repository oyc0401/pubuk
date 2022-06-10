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
  /// [getUserData]에서 [UserProfile]를 불러온다.
  /// [isfirst]가 true면 [userData]에 집어넣고 [isfirst]를 false로 바꾼다.
  /// [userData]는 중요한 역할을 하고있다.
  /// 닉네임, 학년, 반을 바꾸면 이 내부 값을 변화시킨다.
  /// 저장 버튼을 누르면 [userData]에 있는 값을 [saveKey]에 저장하고 화면을 종료한다.
  /// 나중에 로그인을 구현한다면 저장을 할 때 파이어베이스의 유저정보도 함께 바꿔야 한다.

  UserProfile userData = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    print("setstate!");
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              schoolSection(),
              SizedBox(
                height: 40,
              ),
              gradeSection(),
              SizedBox(height: 20),
              classSection(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Save(UserProfile myUserData) async {
    // 로컬 DB에 저장
     UserProfile.save(myUserData);

     print(myUserData);
    // firebase DB에 저장
    FireUser fireUser = FireUser(uid: myUserData.uid);
    fireUser.updateGrade(
      grade: myUserData.grade,
      Class: myUserData.Class,
    );

    // 나가기
    Navigator.of(context).pop('complete');
  }

  Widget schoolSection() {
    return RoundButton(
      text: userData.schoolName,
      onclick: NavigateFindSchool,
      color: Colors.grey,
    );
  }

  Widget gradeSection() {
    int myGrade = userData.grade;
    return RoundButton(
      text: "$myGrade학년",
      onclick: changeGrade,
      color: Colors.greenAccent,
    );
  }

  Widget classSection() {
    int myClass = userData.Class;
    return RoundButton(
      text: "$myClass반",
      onclick: changeClass,
      color: Colors.greenAccent,
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

// navigateHome() {
//   Navigator.pushAndRemoveUntil(
//     context,
//     PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin =  Offset(-1.0, 0);
//         var end = Offset.zero;
//         var curve = Curves.ease;
//
//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//         return Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//               ),
//             ],
//           ),
//           child: SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           ),
//         );
//       },
//     ),
//
//     (route) => false,
//   );
// }
}
