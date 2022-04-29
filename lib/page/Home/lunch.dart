import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Lunch extends StatefulWidget {
  const Lunch({Key? key}) : super(key: key);

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> {
  final FROM_TERM = -30;
  final TO_TERM = 30;

  List MenuArray = [];

  Widget popo = const SizedBox(
      height: 340, child: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    getpost().then((value) {
      MenuArray = lunches(value.menuJson);
      popo = SizedBox(height: 200, child: lunch());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return popo;
  }

  Widget lunch() {
    return PageView(
      controller: PageController(
        initialPage: 30,
        keepPage: true,
      ),
      children: pages(),
    );
  }

  List<Widget> pages() {
    List<Widget> PageViewList = [];

    for (int i = 0; i <= MenuArray.length - 1; i++) {
      PageViewList.add(
        Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: text(i)),
      );
    }

    return PageViewList;
  }

  Widget text(int index) {
    List Menus = MenuArray[index];

    List<Widget> widgets(){
      List<Widget> list=[];
      for (int i = 1; i <= Menus.length - 1; i++) {
        String text = Menus[i];
        list.add(Text(text, overflow: TextOverflow.ellipsis));
      }
      return list;
    };

    Widget page = Container(
      child: Column(
        children: [
          Text(Menus[0]),
          ...widgets()

        ],
      ),
    );

    return page;
  }

  List lunches(Map menuMap) {
    //맵을 받으면 급식 2차원 배열을 리턴한다. [index][11월 22일 월요일, 오므라이스, 쑥갓어묵국, 치즈떡볶이, 수제야채튀김, 배추김치, 사과]

    List lunchArr = [];

    List menuList(String date) {
      // 날짜(yyyyMMdd)를 입력하면 그 날짜의 급식을 담은 1차원 배열을 리턴한다.

      List? list = menuMap[date];
      list ??= ["급식정보가 없습니다."];
      return list;
    }

    String weekdayEng2Kor(String weekEng) {
      String weekKor = "";

      if (weekEng == 'Sun') {
        weekKor = '일';
      } else if (weekEng == 'Mon') {
        weekKor = '월';
      } else if (weekEng == 'Tue') {
        weekKor = '화';
      } else if (weekEng == 'Wed') {
        weekKor = '수';
      } else if (weekEng == 'Thu') {
        weekKor = '목';
      } else if (weekEng == 'Fri') {
        weekKor = '금';
      } else if (weekEng == 'Sat') {
        weekKor = '토';
      }
      weekKor = "$weekKor요일";
      return weekKor;
    }

    final DateTime now = DateTime.now();
    final String fromYMD =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    final String toYMD =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    String plusDayYMD = fromYMD;
    DateTime addedTime = now.add(Duration(days: FROM_TERM));

    while (plusDayYMD != toYMD) {
      String title = DateFormat('MM월 dd일 ').format(addedTime) +
          weekdayEng2Kor(DateFormat('E').format(addedTime));

      lunchArr.add([title, ...menuList(plusDayYMD)]);

      // 추가하고 날짜 하나 올려
      addedTime = addedTime.add(Duration(days: 1));
      plusDayYMD = DateFormat('yyyyMMdd').format(addedTime);
    }
    return lunchArr;
  }

  Future<Postserver> getpost() async {
    var now = new DateTime.now();
    String firstday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530072&"
        "MLSV_FROM_YMD=$firstday&MLSV_TO_YMD=$lastday");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("lunch: 급식 json 파싱 완료 $uri");
      return Postserver.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

// 오른쪽
class Postserver {
  final Map menuJson; // ["20211204"][2]= 12월 4일 2번째 급식이름

  Postserver({required this.menuJson});

  factory Postserver.fromJson(Map<String, dynamic> json) {
    List jsonlist = json["mealServiceDietInfo"][1]["row"];
    Map Lunchmenu = Map(); // ["20211204"][2]= 12월 4일 2번째 급식이름
    List<String> Menus;

    int listLength = jsonlist.length;
    //print("급식 배열 길이: $listLength");
    for (int i = 0; i <= listLength - 1; i++) {
      // 날짜
      String date = jsonlist[i]["MLSV_YMD"];
      //print(date);

      // 문자열 나누기
      Menus = jsonlist[i]["DDISH_NM"].split("<br/>");

      // 코딱지 떼기
      String cleanedData;
      for (int j = 0; j <= Menus.length - 1; j++) {
        cleanedData = Menus[j].replaceAll("-북고", "");
        for (int k = 20; k != 0; k--) {
          cleanedData = cleanedData.replaceAll("$k.", "");
        }
        Menus[j] = cleanedData;
      }

      //print(Menus);
      Lunchmenu[date] = Menus;
    }

    return Postserver(menuJson: Lunchmenu);
  }
}
