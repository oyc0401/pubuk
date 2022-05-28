
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      appBar: appBar(),
      body: body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("부천북고등학교"),
      actions: [
        IconButton(
          onPressed: NavigateProfile,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  ListView body() {
    return ListView(
      children: [
        TimeTableSection(),
        LunchSection(),
        CupertinoButton(
            child: const Text('저장소 확인'),
            onPressed: () {
              checkKey();
            }),
        const SizedBox(height: 30),
        Container(
          height: 400,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget TimeTableSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: timetable(),
    );
  }



  Widget LunchSection() {
    print("런치");
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Lunch(),
    );
  }

  void NavigateProfile() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const profile(),
      ),
    );

    setState(() {});
  }



  Future<void> checkKey() async {
    SaveKeyHandler key = await SaveKeyHandler.Instance();
    key.printAll();
  }
}
