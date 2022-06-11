import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/Server/FireTool.dart';
import 'package:flutterschool/page/Profile/editProfile.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../DB/userProfile.dart';
import '../Profile/profile.dart';
import 'lunch.dart';
import 'timetable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("부천북고등학교"),
        actions: [
          IconButton(
            onPressed: NavigateProfile,
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: ListView(
        children: [
          TimeTableSection(),
          LunchSection(),
          CupertinoButton(
            onPressed: () {
              UserProfile user = UserProfile.currentUser;
              print(user.toMap());
            },
            child: const Text('저장소 확인'),
          ),
          const SizedBox(height: 30),
          Container(
            height: 400,
          ),
        ],
      ),
    );
  }

  Widget TimeTableSection() {

    // MyTimeTable 에 const 붙히면 정보가 바뀌어도 재시작 안함
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: MyTimeTable(),
    );
  }

  Widget LunchSection() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: LunchBuilder(),
    );
  }

  void NavigateProfile() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const profile(),
      ),
    );

    setState(() {
      print(
          "회원 정보가 바뀌었을 수도 있어서 setState 합니다. userProfile: ${UserProfile.currentUser}");
    });
  }

  Future<void> checkKey() async {
    UserProfile userProfile = UserProfile.currentUser;
    print(userProfile);
  }
}
