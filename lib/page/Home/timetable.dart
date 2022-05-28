import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../DB/userProfile.dart';

class timetable extends StatefulWidget {
  timetable({Key? key}) : super(key: key);

  @override
  State<timetable> createState() => _timetableState();
}

class _timetableState extends State<timetable> {
  /// 이 화면은 [getInfo]에서 [UserProfile]를 얻어온다.
  /// 여기서 유저의 학년, 반, 학교코드를 얻어낸다.
  /// 이 값을 사용해 나이스 오픈 데이터 포털에서 시간표 정보를 json 형식으로 가져와 화면을 만들게 된다.
  /// [timetableSection]에 매개변수로 [TableDownloader]에서 가져온 정리된 데이터를 매개변수로 넣게 되면 시간표 위젯을 반환한다.

  int _grade = 0;
  int _class = 0;
  int _schoolCode = 0;
  String _cityCode="J10";

  //Future? GettingDataOnlyOne;

  @override
  void initState() {
    super.initState();
    //GettingDataOnlyOne = getMap();
  }

  getInfo() async {
    UserProfile userData = await UserProfile.Get();
    _grade = userData.getGrade();
    _class = userData.getClass();
    _schoolCode = userData.getSchoolCode();
    _cityCode=userData.getCityCode();

  }

  getMap() async {
    await getInfo();

    TableDownloader tabledown =
        TableDownloader(Grade: _grade, Class: _class, SchoolCode: _schoolCode,CityCode: _cityCode);
    Map cleanedmap = await tabledown.getCleanedMap();

    return cleanedmap;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMap(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return waiting();
          } else if (snapshot.hasError) {
            return error(snapshot);
          } else {
            return succeed(snapshot);
          }
        });
  }

  Widget succeed(AsyncSnapshot<dynamic> snapshot) {
    return Column(
      children: [
        infoSection(),
        timetableSection(snapshot.data),
      ],
    );
  }

  Widget error(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Error: ${snapshot.error}',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget waiting() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 450,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  Widget infoSection() {
    return SizedBox(
      height: 30,
      child: Row(
        children: [Text('$_grade학년 $_class반')],
      ),
    );
  }

  Widget timetableSection(Map cleanedMap) {
    List<TableRow> tableRows() {
      //테이블 총 세로길이 450
      const double height = 60;
      const double halfheight = 30;
      final TextStyle textStyle = const TextStyle(fontSize: 12);

      List<Widget> weekends() {
        List<Widget> list = [];
        list.add(Container(
            height: halfheight,
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
        return list;
      }

      List<Widget> subjects(int num) {
        List<Widget> list = [];
        int kosy = num + 1;
        list.add(Container(
            height: height,
            child: Center(
                child: Text(
              "$kosy",
              textAlign: TextAlign.center,
              style: textStyle,
            ))));
        list.add(Center(
            child: Text(
          cleanedMap["Monday"][num],
          textAlign: TextAlign.center,
          style: textStyle,
        )));
        list.add(Center(
            child: Text(
          cleanedMap["Tuesday"][num],
          textAlign: TextAlign.center,
          style: textStyle,
        )));
        list.add(Center(
            child: Text(
          cleanedMap["Wednesday"][num],
          textAlign: TextAlign.center,
          style: textStyle,
        )));
        list.add(Center(
            child: Text(
          cleanedMap["Thursday"][num],
          textAlign: TextAlign.center,
          style: textStyle,
        )));
        list.add(Center(
            child: Text(
          cleanedMap["Friday"][num],
          textAlign: TextAlign.center,
          style: textStyle,
        )));
        return list;
      }

      List<TableRow> list = [];

      list.add(TableRow(children: [...weekends()]));

      for (int i = 0; i < 7; i++) {
        list.add(TableRow(children: [...subjects(i)]));
      }

      return list;
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
      },
      children: [...tableRows()],
    );
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
  }) {}

  Uri _getUri(int SchoolCode, int Grade, int Class, String CityCode) {
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

  Future _getJson() async {
    // uri값 얻고
    Uri uri = _getUri(SchoolCode, Grade, Class,CityCode);

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("timetable: 시간표 json 파싱 완료 $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Map _cleanMap(Map<String, dynamic> json) {
    // 각 요일의 날짜를 구하기
    DateTime now = DateTime.now();

    List<String> dates = [];
    for (int i = 1; i <= 5; i++) {
      dates.add(DateFormat('yyyyMMdd')
          .format(now.add(Duration(days: -1 * now.weekday + i))));
    }
    //print("이번주 날짜: " + dates.toString());

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

      int listLength = TimeList.length;
      //print("TimeTable: 시간표 배열 길이: $listLength");

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

    //print("TimeTable: $arrMon\n$arrTue\n$arrWed\n$arrThu\n$arrFri");

    return {
      "Monday": arrMon,
      "Tuesday": arrTue,
      "Wednesday": arrWed,
      "Thursday": arrThu,
      "Friday": arrFri,
    };
  }

  Future<Map> getCleanedMap() async {
    Map<String, dynamic> map = await _getJson();
    return _cleanMap(map);
  }
}
