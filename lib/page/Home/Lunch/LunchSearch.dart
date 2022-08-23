import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'Lunch.dart';

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
    allMenuMap = await assetMap();

    setState(() {});
  }

  /// 저장한 json맵
  Future<Map> assetMap() async {
    Map<String, List<String>> allMap =
        {}; // ["급식이름"][20210819, 20210910, 20211005, 20211108];

    Map<String, dynamic> json = await getAsset.getJson();
    JsonToLunch jsonToLunch = JsonToLunch(json: json);
    Map<String, Lunch> lunchmaps = jsonToLunch.currentLunch(false);

    lunchmaps.forEach((date, lunch) {
      for (var dish in lunch.menu) {
        //print(date);
        //print(dish);
        if (allMap[dish] == null) {
          allMap[dish] = [date];
        } else {
          allMap[dish]!.add(date);
        }
      }
    });

    print(allMap);

    return allMap;
  }

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

class getAsset {
  static Future<String> jsonstring() async {
    String jsonString = await rootBundle.loadString('assets/a.json');
    return jsonString;
  }

  static Future<Map<String, dynamic>> getJson() async {
    String jsonString = await jsonstring();
    return json.decode(jsonString);
  }
}


