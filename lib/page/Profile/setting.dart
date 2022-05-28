import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/findschool.dart';

import 'package:select_dialog/select_dialog.dart';

import '../../DB/userProfile.dart';
import '../../DB/saveKey.dart';

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

  UserProfile userData = UserProfile();
  bool isfirst = true;
  Future? GettingDataOnlyOne;

  @override
  void initState() {
    super.initState();
    GettingDataOnlyOne = getUserData();
  }

  Future<UserProfile> getUserData() async {
    print("정보 불러오기!");
    SaveKey saveKey = await SaveKey.Instance();
    return saveKey.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    print("setstate!");
    return Scaffold(
      appBar: appBar(),
      body: body(),
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

  Padding body() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
          future: GettingDataOnlyOne,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return waiting();
            } else if (snapshot.hasError) {
              return error(snapshot);
            } else {
              return succeed(snapshot);
            }
          }),
    );
  }

  Widget succeed(AsyncSnapshot<dynamic> snapshot) {
    if (isfirst) {
      userData = snapshot.data;
      isfirst = false;
    }
    return Column(
      children: [
        schoolSection(),
        nicknameSection(),
        gradeSection(),
        classSection(),
      ],
    );
  }

  Widget error(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Error: ${snapshot.error}',
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget waiting() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 450,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }


  Widget schoolSection() {
    return CupertinoButton(
      child: Text("학교 설정"),
      onPressed: NavigateFindSchool,
    );
  }

  Widget nicknameSection() {
    return Row(
      children: [
        const Text("닉네임:"),
        SizedBox(
          width: 200,
          child: TextFormField(
            onChanged: (text) {
              userData.setNickName(text);
            },
            initialValue: userData.getNickName(),
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget gradeSection() {
    int myGrade = userData.getGrade();

    return Row(
      children: [
        const Text("학년:"),
        TextButton(onPressed: changeGrade, child: Text("$myGrade학년")),
      ],
    );
  }

  Widget classSection() {
    int myClass = userData.getClass();

    return Row(
      children: [
        const Text("반:"),
        TextButton(onPressed: changeClass, child: Text("$myClass반"))
      ],
    );
  }


  Future<void> Save(UserProfile myUserData) async {
    SaveKey key = await SaveKey.Instance();
    key.setUserProfile(myUserData);

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
    int Grade = await getGradeDialog(context, userData.getGrade());
    userData.setGrade(Grade);
    setState(() {});
  }

  Future<void> changeClass() async {
    int Class = await getClassDialog(context, userData.getClass());
    userData.setClass(Class);
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

  // 이 밑은 로그인 구축 했을때 다시 제작
  Future _loadProfile() async {
    // uid = FirebaseAuth.instance.currentUser?.uid ?? '게스트 모드';
    // print("ID: $uid");
  }

  Future Logout() async {
    await FirebaseAuth.instance.signOut();
    SaveKeyHandler key = await SaveKeyHandler.Instance();
    key.SwitchGuest();
    Navigator.of(context).pop('Logout');
  }

  Future DeleteUser(String uid) async {
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
        .doc(uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
