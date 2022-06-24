import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:geolocator/geolocator.dart';

import '../../DB/UserSettingDB.dart';
import 'UnivSearchModel.dart';

class DownLoad extends StatefulWidget {
  const DownLoad({Key? key}) : super(key: key);

  @override
  State<DownLoad> createState() => _DownLoadState();
}

enum Loca { locationDisable, denied, deniedForever }

class _DownLoadState extends State<DownLoad> {
  String text = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: CupertinoButton(
              child: Text("위치"),
              onPressed: () {
                UnivDistance.save();
              })),
    );
  }
}

class Distance {}
