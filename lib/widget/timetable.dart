import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  String text = 'ddd';

  int Grade = 3;
  int Class = 10;
  int SchoolCode = 7530072;
  late Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = TimeTableFetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
      future: post,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TimeTableView(snapshot).buildTable();
        }
        return Container(
            height: 450,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<Post> TimeTableFetchPost() async {
    var now = new DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5


    SharedPreferences prefs = await SharedPreferences.getInstance();
    Grade = prefs.getInt('Grade') ?? 1;
    Class = prefs.getInt('Class') ?? 1;


    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&"
        "SD_SCHUL_CODE=$SchoolCode&GRADE=$Grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("시간표 json 파싱 완료 $uri");
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class TimeTableView {
  late AsyncSnapshot<Post> snapshot;

  TimeTableView(this.snapshot);

  Table buildTable() {
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

  double height = 60;
  double halfheight = 30;

  List<TableRow> tableRows() {
    List<TableRow> list = [];
    list.add(TableRow(children: [...weekends()]));
    for (int i = 0; i <= 6; i++) {
      list.add(TableRow(children: [...subjects(i)]));
    }
    return list;
  }

  TextStyle textStyle() => TextStyle(fontSize: 12);

  List<Widget> weekends() {
    List<Widget> list = [];
    list.add(Container(
        height: halfheight,
        child: Center(
            child: Text(
          " ",
          style: textStyle(),
        ))));
    list.add(Text(
      "월요일",
      textAlign: TextAlign.center,
      style: textStyle(),
    ));
    list.add(Text(
      "화요일",
      textAlign: TextAlign.center,
      style: textStyle(),
    ));
    list.add(Text(
      "수요일",
      textAlign: TextAlign.center,
      style: textStyle(),
    ));
    list.add(Text(
      "목요일",
      textAlign: TextAlign.center,
      style: textStyle(),
    ));
    list.add(Text(
      "금요일",
      textAlign: TextAlign.center,
      style: textStyle(),
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
          style: textStyle(),
        ))));
    list.add(Center(
        child: Text(
      snapshot.data!.Mon[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
      snapshot.data!.Tue[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
      snapshot.data!.Wed[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
      snapshot.data!.Thu[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
      snapshot.data!.Fri[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    return list;
  }
}

class Post {
  final List<String> Mon, Tue, Wed, Thu, Fri;

  Post({
    required this.Mon,
    required this.Tue,
    required this.Wed,
    required this.Thu,
    required this.Fri,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // 요일의 날짜 구하기
    var mon, tue, wed, thu, fri;
    var now = new DateTime.now();
    mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    tue = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 2)));
    wed = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 3)));
    thu = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 4)));
    fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5
    print("월요일: $mon 화요일: $tue 수요일: $wed 목요일: $thu 금요일: $fri");

    List<String> arrMon = [],
        arrTue = [],
        arrWed = [],
        arrThu = [],
        arrFri = [];

    if (json['hisTimetable'] == null) {
    } else if (json['hisTimetable'][0]['head'][1]['RESULT']['MESSAGE'] ==
        "정상 처리되었습니다.") {
      // List에 요일별로 저장하기
      List jsonfull = json['hisTimetable'][1]['row'];
      int listLength = jsonfull.length;
      print("시간표 배열 길이: $listLength");
      for (int i = 0; i <= jsonfull.length - 1; i++) {
        var date = jsonfull[i]['ALL_TI_YMD'];
        var subject = jsonfull[i]['ITRT_CNTNT'];
        if (date == mon)
          arrMon.add(subject);
        else if (date == tue)
          arrTue.add(subject);
        else if (date == wed)
          arrWed.add(subject);
        else if (date == thu)
          arrThu.add(subject);
        else if (date == fri) arrFri.add(subject);
      }
    }

    // 빈칸 채워주기
    while (arrMon.length <= 6) arrMon.add('');
    while (arrTue.length <= 6) arrTue.add('');
    while (arrWed.length <= 6) arrWed.add('');
    while (arrThu.length <= 6) arrThu.add('');
    while (arrFri.length <= 6) arrFri.add('');

    print("$arrMon\n$arrTue\n$arrWed\n$arrThu\n$arrFri");

    return Post(
      Mon: arrMon,
      Tue: arrTue,
      Wed: arrWed,
      Thu: arrTue,
      Fri: arrFri,
    );
  }
}
