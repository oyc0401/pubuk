
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TimeTable extends StatefulWidget {
  TimeTable({Key? key,required this.post}) : super(key: key);
Post post;

  @override
  _TimeTableState createState() => _TimeTableState();
}
class _TimeTableState extends State<TimeTable> {
  String text = 'ddd';

  @override
  Widget build(BuildContext context) {
          return TimeTableView(widget.post).TimeTableWidget();
  }
}

class TimeTableView {
  late Post post;

  TimeTableView(this.post);

  Table TimeTableWidget() {
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
      post.Mon[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
          post.Tue[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
          post.Wed[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
          post.Thu[num],
      textAlign: TextAlign.center,
      style: textStyle(),
    )));
    list.add(Center(
        child: Text(
          post.Fri[num],
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
    print("TimeTable: 월요일: $mon 화요일: $tue 수요일: $wed 목요일: $thu 금요일: $fri");

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
      print("TimeTable: 시간표 배열 길이: $listLength");
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

    print("TimeTable: $arrMon\n$arrTue\n$arrWed\n$arrThu\n$arrFri");

    return Post(
      Mon: arrMon,
      Tue: arrTue,
      Wed: arrWed,
      Thu: arrTue,
      Fri: arrFri,
    );
  }
}
