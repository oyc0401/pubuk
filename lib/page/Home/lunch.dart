import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skeletons/skeletons.dart';

import '../../DB/userProfile.dart';

class LunchBuilder extends StatefulWidget {
  const LunchBuilder({Key? key}) : super(key: key);

  @override
  _LunchBuilderState createState() => _LunchBuilderState();
}

class _LunchBuilderState extends State<LunchBuilder> {
  /// [getLunch]로 나이스 오픈 데이터 포털에서 급식 정보를 가져온다.

  Future<List<Lunch>> getLunch() async {
    UserProfile userData = UserProfile.currentUser;
    int schoolCode = userData.schoolCode;
    String cityCode = userData.schoolLocalCode;

    LunchDownloader lunchDownloader =
        LunchDownloader(SchoolCode: schoolCode, CityCode: cityCode);
    await lunchDownloader.downLoad();
    return lunchDownloader.getLunches();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLunch(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return waiting();
        } else if (snapshot.hasError) {
          return error(snapshot);
        } else {
          return waiting();
          //return succeed(snapshot);
          //  return waiting();
        }
      },
    );
  }

  Widget succeed(AsyncSnapshot<dynamic> snapshot) {
    List<Lunch> lunches = snapshot.data;
    return LunchScroll(lunches: lunches);
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
    return const SkeletonScroll();
  }
}

class LunchScroll extends StatelessWidget {
  /// Lunch 배열로 만드는 스크롤 위젯

  List<Lunch> lunches;
  LunchScroll({
    Key? key,
    required this.lunches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: 30, // 0 ~ 29, 30, 31~60 <= 총 61개
        scrollDirection: Axis.horizontal,
        itemCount: 61,
        itemBuilder: (context, index) {
          Color color = Colors.black;
          if (index == 30) {
            color = Colors.blue;
          }
          return LunchContainer(
            lunch: lunches[index],
            lineColor: color,
          );
        },
      ),
    );
  }
}

class LunchContainer extends StatelessWidget {
  /// Lunch 사각형 박스 객체
  /// skeleton 설정도 가능하다.

  Lunch lunch;
  Color lineColor;
  bool isSkeleton;

  LunchContainer({
    Key? key,
    required this.lunch,
    this.isSkeleton = false,
    this.lineColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: lineColor),
      ),
      child: Column(
        children: [titleSection(), foodSection()],
      ),
    );
  }

  Widget titleSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: skeletonText(lunch.date),
    );
  }

  Widget foodSection() {
    List<Widget> list = [];

    for (String text in lunch.menu) {
      list.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: skeletonText(text),
      ));
    }

    return Column(
      children: list,
    );
  }

  Widget skeletonText(String text) {
    return Skeleton(
      isLoading: isSkeleton,
      skeleton: const Padding(
        padding: EdgeInsets.all(3.0),
        child:
        SkeletonAvatar(style: SkeletonAvatarStyle(width: 100, height: 14)),
      ),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}

class SkeletonScroll extends StatelessWidget {
  const SkeletonScroll({Key? key}) : super(key: key);

  /// skeleton 스크롤 위젯

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: 5, // 0 1 2 3 4 , 5, 6 7 8 9 10
        scrollDirection: Axis.horizontal,
        itemCount: 11,
        itemBuilder: (context, index) {
          Color color = Colors.black;
          if (index == 5) {
            color = Colors.blue;
          }
          return LunchContainer(
            lunch: Lunch(
              date: "",
              menu: List.generate(6, (index) => ""),
            ),
            lineColor: color,
            isSkeleton: true,
          );
        },
      ),
    );
    
  }
}

class Lunch {
  /// 하루의 점심 정보를 담고있는 객체

  String date;
  List<String> menu;

  Lunch({
    required this.date,
    required this.menu,
  });
}

class LunchDownloader {
  /// 급식 사진 다운로드

  int SchoolCode;
  String CityCode;
  final int FROM_TERM = -30;
  final int TO_TERM = 30;

  LunchDownloader({
    required this.CityCode,
    required this.SchoolCode,
  });

  late Map<String, dynamic> Json;

  Future<void> downLoad() async => Json = await _getJson();

  List<Lunch> getLunches() => _cleanLunch(_washMap(Json));

  Uri _getUri(int SchoolCode, String CityCode) {
    DateTime now = DateTime.now();
    String firstday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=$CityCode&SD_SCHUL_CODE=$SchoolCode&"
        "MLSV_FROM_YMD=$firstday&MLSV_TO_YMD=$lastday");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    // 날짜 프린트
    DateTime now = DateTime.now();
    String firstday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    // uri값 얻고
    Uri uri = _getUri(SchoolCode, CityCode);

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("$firstday ~ $lastday 급식메뉴: $uri");
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

  List<Lunch> _cleanLunch(Map<String, List<String>> washedMap) {
    //맵을 받으면 급식 2차원 배열을 리턴한다. [index][11월 22일 월요일, 오므라이스, 쑥갓어묵국, 치즈떡볶이, 수제야채튀김, 배추김치, 사과]

    //print(cleanedMap);
    List<Lunch> boxes = [];

    List<String> foodList(String date) {
      // 날짜(yyyyMMdd)를 입력하면 그 날짜의 급식을 담은 1차원 배열을 리턴한다.

      List<String>? list = washedMap[date];
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
    final String goleYMD = DateFormat('yyyyMMdd').format(now.add(Duration(
        days: TO_TERM +
            1))); //+1 해주는 이유는 while문에서 -30~+30까지 가야하는데 -30~+29까지 가서 하나 더 붙여준거임 나중에 좋은 방법 나오면 고쳐야함

    // 목표 날짜 구하기
    DateTime plusDateTime = now.add(Duration(days: FROM_TERM));
    String plusYMD = DateFormat('yyyyMMdd').format(plusDateTime);

    // 더한 날짜가 마지막 날짜가 될 때 까지
    while (plusYMD != goleYMD) {
      // 박스 안 제목 설정하기
      String date = DateFormat('MM월 dd일 ').format(plusDateTime);
      String weekday = weekdayEng2Kor(DateFormat('E').format(plusDateTime));
      String title = "$date $weekday";

      // 배열에 메뉴 추가
      boxes.add(Lunch(date: title, menu: foodList(plusYMD)));

      // 추가하고 날짜 하나 올리기
      plusDateTime = plusDateTime.add(Duration(days: 1));
      plusYMD = DateFormat('yyyyMMdd').format(plusDateTime);
    }

    return boxes;
  }

// json은 원본상태
// wash는 불순물 제거
// clean은 사용하기 좋게 변환
}
