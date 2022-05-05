import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterschool/DB/UserData.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Lunch extends StatefulWidget {
  const Lunch({Key? key}) : super(key: key);

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> {
  /// 이 화면은 [getInfo]에서 [UserData]를 얻어온다.
  /// 여기서 유저의 학교코드를 얻어낸다.
  /// 이 값을 사용해 나이스 오픈 데이터 포털에서 급식 정보를 json 형식으로 가져와 화면을 만들게 된다.
  /// [lunchSection]에 매개변수로 [LunchDownloader]에서 가져온 정리된 데이터를 매개변수로 넣게 되면 급식 위젯을 반환한다.
  int _schoolCode = 0;

  Future? GettingDataOnlyOne;

  @override
  void initState() {
    super.initState();
    GettingDataOnlyOne = getList();
  }

  getInfo() async {
    SaveKey key = await SaveKey.Instance();
    UserData userData = key.getUserData();
    _schoolCode = userData.getSchoolCode();
  }

  getList() async {
    await getInfo();

    LunchDownloader lunchDownloader = LunchDownloader(SchoolCode: _schoolCode);
    return await lunchDownloader.getCleanedList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GettingDataOnlyOne,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return waiting();
        } else if (snapshot.hasError) {
          return error(snapshot);
        } else {
          return succeed(snapshot);
        }
      },
    );
  }

  Widget succeed(AsyncSnapshot<dynamic> snapshot) {
    return lunchSection(snapshot.data);
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
    return const SizedBox(
      height: 340,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget lunchSection(List<List<String>> menu) {
    List<Widget> pages() {
      List<Widget> list = [];

      menu.forEach((element) {
        list.add(box(element));
      });

      return list;
    }

    return SizedBox(
      height: 200,
      child: PageView(
        controller: PageController(
          initialPage: 30,
          keepPage: true,
        ),
        children: pages(),
      ),
    );
  }

  Widget box(List<String> foods) {
    Widget titleSection() {
      return Text(foods[0]);
    }

    Widget foodSection() {
      List<Widget> list = [];

      for (int i = 1; i < foods.length; i++) {
        String text = foods[i];
        list.add(Text(text, overflow: TextOverflow.ellipsis));
      }

      return Column(
        children: list,
      );
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [titleSection(), foodSection()],
      ),
    );
  }
}

class LunchDownloader {
  int SchoolCode;
  final int FROM_TERM = -30;
  final int TO_TERM = 30;

  LunchDownloader({required this.SchoolCode}) {}

  Uri _getUri(int SchoolCode) {
    var now = new DateTime.now();
    String firstday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=$SchoolCode&"
        "MLSV_FROM_YMD=$firstday&MLSV_TO_YMD=$lastday");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    // uri값 얻고
    Uri uri = _getUri(SchoolCode);

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("Lunch: 급식 json 파싱 완료 $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Map<String, List<String>> _washMap(Map<String, dynamic> json) {
    Map<String, List<String>> cleanMap = {}; // ["20211204"][2]= 12월 4일 2번째 급식이름

    List<String> foodsWashing(Map map) {
      // 문자열 나누기
      List<String> foods = map["DDISH_NM"].split("<br/>");

      // 코딱지 떼기
      for (int i = 0; i < foods.length; i++) {
        String cleanedData = foods[i].replaceAll("북고", "");

        for (int k = 20; k > 0; k--) {
          cleanedData = cleanedData.replaceAll("$k.", "");
        }

        cleanedData = cleanedData.replaceAll("-", "");
        cleanedData = cleanedData.replaceAll("_", "");
        cleanedData = cleanedData.replaceAll("()", "");
        cleanedData = cleanedData.replaceAll(" ", "");

        foods[i] = cleanedData;
      }

      return foods;
    }

    List jsonlist = json["mealServiceDietInfo"][1]["row"];

    jsonlist.forEach((element) {
      String date = element["MLSV_YMD"];
      List<String> foods = foodsWashing(element);
      cleanMap[date] = foods;
    });

    return cleanMap;
  }

  List<List<String>> _cleanList(Map<String, List<String>> cleanedMap) {
    //맵을 받으면 급식 2차원 배열을 리턴한다. [index][11월 22일 월요일, 오므라이스, 쑥갓어묵국, 치즈떡볶이, 수제야채튀김, 배추김치, 사과]

    print(cleanedMap);
    List<List<String>> Menu = [];

    List foodList(String date) {
      // 날짜(yyyyMMdd)를 입력하면 그 날짜의 급식을 담은 1차원 배열을 리턴한다.

      List? list = cleanedMap[date];
      list ??= ["급식정보가 없습니다."];
      return list;
    }

    String weekdayEng2Kor(String weekEng) {
      // 영어 요일을 한국어로 변환

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

    // 목표 날짜 구하기
    DateTime plusDateTime = now.add(Duration(days: FROM_TERM));
    String plusYMD = DateFormat('yyyyMMdd').format(plusDateTime);

    print(fromYMD);
    print(toYMD);
    print("YMD: $plusYMD");
    print("date: $plusDateTime");

    // 더한 날짜가 마지막 날짜가 될 때 까지
    while (plusYMD != toYMD) {
      // 박스 안 제목 설정하기
      String date = DateFormat('MM월 dd일 ').format(plusDateTime);
      String weekday = weekdayEng2Kor(DateFormat('E').format(plusDateTime));
      String title = "$date $weekday";

      // 배열에 메뉴 추가
      Menu.add([title, ...foodList(plusYMD)]);

      // 추가하고 날짜 하나 올리기
      plusDateTime = plusDateTime.add(Duration(days: 1));
      plusYMD = DateFormat('yyyyMMdd').format(plusDateTime);
    }

    return Menu;
  }

  Future<List<List<String>>> getCleanedList() async {
    Map<String, dynamic> json = await _getJson();
    Map<String, List<String>> washedMap = _washMap(json);
    return _cleanList(washedMap);
  }

// json은 원본상태
// wash는 불순물 제거
// clean은 사용하기 좋게 변환
}
