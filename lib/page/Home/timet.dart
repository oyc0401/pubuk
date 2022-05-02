import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutterschool/page/Home/timetable.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../DB/UserData.dart';
import '../../DB/saveKey.dart';

import 'package:http/http.dart' as http;

class timet {
  int Grade;
  int Class;
  int SchoolCode;

  timet({required this.Grade, required this.Class, required this.SchoolCode}) {}

  Uri _getUri(int SchoolCode, int Grade, int Class) {
    var now = DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&"
        "SD_SCHUL_CODE=$SchoolCode&GRADE=$Grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");
    return uri;
  }

  Future getJson() async {
    // uri값 얻고
    Uri uri = _getUri(SchoolCode, Grade, Class);

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("home: 시간표 json 파싱 완료 $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Map timeMap(Map<String, dynamic> json) {
    // 각 요일의 날짜를 구하기
    DateTime now = DateTime.now();

    List<String> dates = [];
    for (int i = 1; i <= 5; i++) {
      dates.add(DateFormat('yyyyMMdd')
          .format(now.add(Duration(days: -1 * now.weekday + i))));
    }
    print("이번주 날짜: " + dates.toString());

    // 과목이 담길 리스트를 만든다
    List<String> arrMon = [],
        arrTue = [],
        arrWed = [],
        arrThu = [],
        arrFri = [];

//     List? a=json['hisTimetable']?? [{}];
//     Map? b= a![0]??{};
//     List? c=b!['head']??[{}];
//     Map? d=c![1]??{};
//     Map? e=d!['RESULT']??{};
//     String? message=e!['MESSAGE']??"데이터를 불러올 수 없습니다.";
// print(message);



    if (json['hisTimetable'] == null) {
      String message="데이터가 없습니다.";
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

      int listLength = TimeList.length;
      print("TimeTable: 시간표 배열 길이: $listLength");

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

    // 빈칸 채워주기
    while (arrMon.length <= 6) {
      arrMon.add('');
    }
    while (arrTue.length <= 6) {
      arrTue.add('');
    }
    while (arrWed.length <= 6) {
      arrWed.add('');
    }
    while (arrThu.length <= 6) {
      arrThu.add('');
    }
    while (arrFri.length <= 6) {
      arrFri.add('');
    }

    print("TimeTable: $arrMon\n$arrTue\n$arrWed\n$arrThu\n$arrFri");

    return {
      "Monday": arrMon,
      "Tuesday": arrTue,
      "Wednesday": arrWed,
      "Thursday": arrThu,
      "Friday": arrFri,
    };
  }
}
