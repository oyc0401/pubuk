import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../AllMap.dart';
import '../Lunch.dart';

class LunchSearch extends StatefulWidget {
  const LunchSearch({Key? key}) : super(key: key);

  @override
  State<LunchSearch> createState() => _LunchSearchState();
}

class _LunchSearchState extends State<LunchSearch> {
  Map allMenuMap = {};
  String lunchImageTitle = "뭔가 오류가 있다.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    allMenuMap = await LunchAllMap.assetMap();

    setState(() {});
  }

  /// 저장한 json맵

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SelectableText(
          "${allMenuMap.toString()}\n\n             ",
          scrollPhysics: ClampingScrollPhysics(),
          toolbarOptions:
              ToolbarOptions(copy: true, selectAll: true, cut: true),
        ),
        // child: Text(
        //   allMenuMap.toString(),
        // ),
      ),
    );
  }
}
