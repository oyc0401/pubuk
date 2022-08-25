import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../HomeModel.dart';
import 'ClassData.dart';

class MyTimeTable extends StatelessWidget {
  const MyTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClassData? classData = Provider.of<HomeModel>(context).classData;
    if (classData == null) {
      return Skeleton(
        isLoading: true,
        skeleton: const SkeletonAvatar(
            style: SkeletonAvatarStyle(width: 480, height: 380)),
        child: Container(),
      );
    } else {
      return TimeTable(
        height: 380,
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

  //테이블 총 세로길이 380
  late double boxHeight;
  late double boxSmallHeight;

  double percent = 0.4;
  int maxLenght;

  TimeTable({
    Key? key,
    this.maxLenght = 7,
    double height = 380,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(color: Colors.black, spreadRadius: 1),
        // ],
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   // border: Border.all(),
      // ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Color(0xfff8f8f8), width: 1.5),
        columnWidths: {
          0: FlexColumnWidth(percent),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: tableRows(),
      ),
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
    var weekday = DateTime.now().weekday;

    print(weekday);

    return TableRow(children: [
      TableSideUnit(
        height: boxSmallHeight,
        text: ' ',
      ),
      TableSideUnit(
        height: boxSmallHeight,
        text: '월',
        light: weekday == 1,
      ),
      TableSideUnit(
        height: boxSmallHeight,
        text: '화',
        light: weekday == 2,
      ),
      TableSideUnit(
        height: boxSmallHeight,
        text: '수',
        light: weekday == 3,
      ),
      TableSideUnit(
        height: boxSmallHeight,
        text: '목',
        light: weekday == 4,
      ),
      TableSideUnit(
        height: boxSmallHeight,
        text: '금',
        light: weekday == 5,
      ),
    ]);
  }

  TableRow subjects({required int index}) {
    var weekday = DateTime.now().weekday;

    return TableRow(children: [
      TableSideUnit(
        height: boxHeight,
        text: "${index + 1}",
      ),
      TableUnit(
        height: boxHeight,
        text: monday[index],
        light: weekday == 1,
      ),
      TableUnit(
        height: boxHeight,
        text: tuesday[index],
        light: weekday == 2,
      ),
      TableUnit(
        height: boxHeight,
        text: wednesday[index],
        light: weekday == 3,
      ),
      TableUnit(
        height: boxHeight,
        text: thursday[index],
        light: weekday == 4,
      ),
      TableUnit(
        height: boxHeight,
        text: friday[index],
        light: weekday == 5,
      ),
    ]);
  }
}

class TableUnit extends StatelessWidget {
  TableUnit(
      {Key? key, required this.text, required this.height, this.light = false})
      : super(key: key);

  double height;
  String text;
  bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: light ? Color(0x2fc3edff) : Colors.white,
        //color: light? Colors.blue:null,
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     width: 1,
        //     color: Color(0xffe0e0e0),
        //   ),
        // ),
        height: height,
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.fade,
        )));

    // return Text(
    //   text,
    //   textAlign: TextAlign.center,
    //   style: const TextStyle(fontSize: 12),
    // );
  }
}

class TableSideUnit extends StatelessWidget {
  TableSideUnit(
      {Key? key, required this.text, required this.height, this.light = false})
      : super(key: key);

  double height;
  String text;
  bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: light? Color(0x2f9cd2ff):Colors.white,
        //color: light? Colors.blue:null,
        height: height,
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        )));

    // return Text(
    //   text,
    //   textAlign: TextAlign.center,
    //   style: const TextStyle(fontSize: 12),
    // );
  }
}


