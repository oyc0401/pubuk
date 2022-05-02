import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'timet.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key? key, required this.MMMap}) : super(key: key);
  Map MMMap;

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {

  @override
  Widget build(BuildContext context) {
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

  //테이블 총 세로길이 450
  final double height = 60;
  final double halfheight = 30;
  final TextStyle textStyle = const TextStyle(fontSize: 12);

  List<TableRow> tableRows() {
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


    //"Monday":arrMon,
    //       "Tuesday":arrTue,
    //       "Wednesday":arrWed,
    //       "Thursday":arrThu,
    //       "Friday"
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
        widget.MMMap["Monday"][num],
        textAlign: TextAlign.center,
        style: textStyle,
      )));
      list.add(Center(
          child: Text(
        widget.MMMap["Tuesday"][num],
        textAlign: TextAlign.center,
        style: textStyle,
      )));
      list.add(Center(
          child: Text(
        widget.MMMap["Wednesday"][num],
        textAlign: TextAlign.center,
        style: textStyle,
      )));
      list.add(Center(
          child: Text(
        widget.MMMap["Thursday"][num],
        textAlign: TextAlign.center,
        style: textStyle,
      )));
      list.add(Center(
          child: Text(
        widget.MMMap["Friday"][num],
        textAlign: TextAlign.center,
        style: textStyle,
      )));
      return list;
    }

    List<TableRow> list = [];
    list.add(TableRow(children: [...weekends()]));
    for (int i = 0; i <= 6; i++) {
      list.add(TableRow(children: [...subjects(i)]));
    }
    return list;
  }
}


