import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:provider/provider.dart';

import '../Profile/profile.dart';
import 'HomeModel.dart';
import 'currentUserWidget.dart';
import 'lunch.dart';
import 'timetable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void NavigateProfile() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const profile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xfffbfbfb),
      appBar: buildAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyTimeTable(),
          ),
          // MyTimeTable(),
           const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: LunchBuilder(),
          ),
          // Container(
          //   height: 400,
          // ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    print(UserProfile.currentUser.toString());
    return AppBar(
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<HomeModel>(context).schoolName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.normal),
          ),
          Text(
            '${Provider.of<HomeModel>(context).grade}학년 ${Provider.of<HomeModel>(context).Class}반',
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      //backgroundColor: Colors.blue,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 24,right: 8),
          child: IconButton(
            onPressed: NavigateProfile,
            icon: const Icon(
              Icons.person_outlined,
              size: 28,
              color: Color(0xff191919),

            ),
          ),
        ),
      ],
    );
  }

}

