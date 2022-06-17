import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import 'HomeModel.dart';


class MyTimeTable extends StatelessWidget {
  const MyTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClassData? classData = Provider.of<HomeModel>(context).classData;
    if(classData==null){
       return Skeleton(
        isLoading: true,
        skeleton: const SkeletonAvatar(
            style: SkeletonAvatarStyle(width: 480, height: 450)),
        child: Container(),
      );
    }else{
      return TimeTable(
        height: 450,
        percent: 0.4,
        monday: classData.Mon,
        tuesday: classData.Tue,
        wednesday: classData.Wed,
        thursday: classData.Thu,
        friday: classData.Fri,
      );
    }
  }
}

class TimeTable extends StatelessWidget {
  List<String> monday;
  List<String> tuesday;
  List<String> wednesday;
  List<String> thursday;
  List<String> friday;

  //테이블 총 세로길이 450
  double boxHeight = 0;
  double boxSmallHeight = 0;

  double percent = 0.5;
  int maxLenght;

  final TextStyle textStyle = const TextStyle(fontSize: 12);

  TimeTable({
    Key? key,
    this.maxLenght = 7,
    double height = 450,
    this.percent = 0.5,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
  }) : super(key: key) {
    boxHeight = height / (maxLenght + percent);
    boxSmallHeight = percent * boxHeight;

    // 빈칸 채워주기
    while (monday.length < maxLenght) {
      monday.add('');
    }
    while (tuesday.length < maxLenght) {
      tuesday.add('');
    }
    while (wednesday.length < maxLenght) {
      wednesday.add('');
    }
    while (thursday.length < maxLenght) {
      thursday.add('');
    }
    while (friday.length < maxLenght) {
      friday.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(percent),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      children: tableRows(),
    );
  }

  List<TableRow> tableRows() {
    List<TableRow> value = [];

    value.add(firstBar());

    for (int i = 0; i < maxLenght; i++) {
      value.add(subjects(index: i));
    }

    return value;
  }

  TableRow firstBar() {
    List<Widget> list = [];

    list.add(Container(
        height: boxSmallHeight,
        child: Center(
            child: Text(
          " ",
          style: textStyle,
        ))));
    list.add(Text(
      "월요일",
      textAlign: TextAlign.center,
      style: textStyle,
    ));
    list.add(Text(
      "화요일",
      textAlign: TextAlign.center,
      style: textStyle,
    ));
    list.add(Text(
      "수요일",
      textAlign: TextAlign.center,
      style: textStyle,
    ));
    list.add(Text(
      "목요일",
      textAlign: TextAlign.center,
      style: textStyle,
    ));
    list.add(Text(
      "금요일",
      textAlign: TextAlign.center,
      style: textStyle,
    ));

    return TableRow(children: list);
  }

  TableRow subjects({required int index}) {
    List<Widget> list = [];

    int kosy = index + 1;
    list.add(Container(
        height: boxHeight,
        child: Center(
            child: Text(
          "$kosy",
          textAlign: TextAlign.center,
          style: textStyle,
        ))));
    list.add(Center(
        child: Text(
      monday[index],
      textAlign: TextAlign.center,
      style: textStyle,
    )));
    list.add(Center(
        child: Text(
      tuesday[index],
      textAlign: TextAlign.center,
      style: textStyle,
    )));
    list.add(Center(
        child: Text(
      wednesday[index],
      textAlign: TextAlign.center,
      style: textStyle,
    )));
    list.add(Center(
        child: Text(
      thursday[index],
      textAlign: TextAlign.center,
      style: textStyle,
    )));
    list.add(Center(
        child: Text(
      friday[index],
      textAlign: TextAlign.center,
      style: textStyle,
    )));

    return TableRow(children: list);
  }
}

class TableDownloader {
  int Grade;
  int Class;
  String CityCode;
  int SchoolCode;

  TableDownloader({
    required this.Grade,
    required this.Class,
    required this.CityCode,
    required this.SchoolCode,
  });

  late Map<String, dynamic> Json;

  Future<void> downLoad() async => Json = await _getJson();

  ClassData getData() => _Data(Json);

  Uri _MyUri() {
    var now = DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&Type=json&pIndex=1&pSize=1000&"
        "ATPT_OFCDC_SC_CODE=$CityCode&SD_SCHUL_CODE=$SchoolCode&GRADE=$Grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    // uri값 얻고
    Uri uri = _MyUri();

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("$Grade학년 $Class반 시간표 url: $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  ClassData _Data(Map<String, dynamic> json) {
    // 각 요일의 날짜를 구하기
    final DateTime now = DateTime.now();

    List<String> dates = [];
    for (int i = 1; i <= 5; i++) {
      dates.add(DateFormat('yyyyMMdd')
          .format(now.add(Duration(days: -1 * now.weekday + i))));
    }

    // 과목이 담길 리스트를 만든다
    List<String> arrMon = [],
        arrTue = [],
        arrWed = [],
        arrThu = [],
        arrFri = [];

    if (json['hisTimetable'] == null) {
      String message = "데이터가 없습니다.";
      arrMon.add(message);
      arrTue.add(message);
      arrWed.add(message);
      arrThu.add(message);
      arrFri.add(message);
    } else if (json['hisTimetable'][0]['head'][1]['RESULT']['MESSAGE'] ==
        "정상 처리되었습니다.") {
      // List에 요일별로 저장하기

      // 이 리스트는 시간 맵이 모두 들어있는 리스트
      List TimeList = json['hisTimetable'][1]['row'];

      for (int i = 0; i < TimeList.length; i++) {
        final String date = TimeList[i]['ALL_TI_YMD'];
        final String subject = TimeList[i]['ITRT_CNTNT'];

        if (date == dates[0]) {
          arrMon.add(subject);
        } else if (date == dates[1]) {
          arrTue.add(subject);
        } else if (date == dates[2]) {
          arrWed.add(subject);
        } else if (date == dates[3]) {
          arrThu.add(subject);
        } else if (date == dates[4]) {
          arrFri.add(subject);
        }
      }
    }

    return ClassData(
        Mon: arrMon, Tue: arrTue, Wed: arrWed, Thu: arrThu, Fri: arrFri);
  }
}

class ClassData {
  List<String> Mon, Tue, Wed, Thu, Fri;

  ClassData({
    required this.Mon,
    required this.Tue,
    required this.Wed,
    required this.Thu,
    required this.Fri,
  });
}
