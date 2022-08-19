
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/ProfileModel.dart';
import 'package:flutterschool/page/Profile/findschool.dart';
import 'package:flutterschool/MyWidget/button.dart';
import 'package:flutterschool/page/Profile/selectSchool.dart';
import 'package:provider/provider.dart';

import 'package:select_dialog/select_dialog.dart';

import '../../DB/userProfile.dart';
import '../../Server/FireTool.dart';
import '../Home/HomeModel.dart';
import '../mainPage.dart';


class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  initState() {
    super.initState();
    Provider.of<EditProfileModel>(context, listen: false).reset();
  }

  Future<void> save() async {
    await Provider.of<EditProfileModel>(context, listen: false).saveLocal();
   // await Provider.of<EditProfileModel>(context, listen: false).saveFireBase();
    Provider.of<HomeModel>(context, listen: false).setTimeTable(UserProfile.currentUser);
    Provider.of<HomeModel>(context, listen: false).setLunch(UserProfile.currentUser);

    // 나가기
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(),
        ),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '학교 정보를 입력해주세요',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            RoundTextButton(
              text: Provider.of<EditProfileModel>(context).schoolName,
              onclick: NavigateSelectSchool,
              color: Color(0xffb4d5ff),
            ),
            SizedBox(
              height: 40,
            ),
            RoundTextButton(
              text: "${Provider.of<EditProfileModel>(context).grade}학년",
              onclick: changeGrade,
              color: Color(0xffeeeeee),
            ),
            SizedBox(
              height: 15,
            ),
            RoundTextButton(
              text: "${Provider.of<EditProfileModel>(context).Class}반",
              onclick: changeClass,
              color: Color(0xffeeeeee),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RoundTextButton(
        onclick: () => save(),
        text: '저장',
        color: Color(0xffFFEC83),
        fontSize: 20,
      ),
    );
  }

  Future<void> changeGrade() async {
    int initGrade = Provider.of<EditProfileModel>(context, listen: false).grade;
    await SelectDialog.showModal<String>(
      context,
      label: "학년을 선택하세요",
      selectedValue: "${initGrade}학년",
      items: List.generate(3, (index) {
        var num = index + 1;
        return "$num학년";
      }),
      onChange: (String selected) {
        setState(() {
          print(selected);
          var dd = selected.split('');
          initGrade = int.parse(dd[0]);
          Provider.of<EditProfileModel>(context, listen: false).setGrade(initGrade);
        });
      },
      showSearchBox: false,
    );
  }

  Future<void> changeClass() async {
    int initClass = Provider.of<EditProfileModel>(context, listen: false).Class;
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
        Provider.of<EditProfileModel>(context, listen: false).setClass(initClass);
      },
      showSearchBox: false,
    );
  }

  void NavigateSelectSchool() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SelectSchool(),
      ),
    );
  }
}

