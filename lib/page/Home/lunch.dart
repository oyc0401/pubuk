import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/page/Home/HomeModel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skeletons/skeletons.dart';

const int FROM_TERM = -30;
const int TO_TERM = 30;

class LunchBuilder extends StatelessWidget {
  const LunchBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Lunch>? lunches = Provider.of<HomeModel>(context).lunches;

    if (lunches == null) {
      return const SkeletonScroll();
    } else {
      return LunchScroll(lunches: lunches);
    }
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
      height: 220,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: -FROM_TERM, // 0 ~ 29, 30, 31~60 <= 총 61개
        scrollDirection: Axis.horizontal,
        itemCount: -FROM_TERM + 1 + TO_TERM,
        itemBuilder: (context, index) {
          Color color = Colors.black;
          if (index == -FROM_TERM) {
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
      height: 220,
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

  int schoolCode;
  String cityCode;

  LunchDownloader({
    required this.cityCode,
    required this.schoolCode,
  });

  late Map<String, dynamic> Json;


  /// 실행 함수
  Future<void> downLoad() async => Json = await _getJson();

  List<Lunch> getLunches() => _addBlankLunch(_lunches(Json));


  /// json 얻기
  Uri get _uri {
    DateTime now = DateTime.now();
    String firstday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastday =
        DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
        "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=$cityCode&SD_SCHUL_CODE=$schoolCode&"
        "MLSV_FROM_YMD=$firstday&MLSV_TO_YMD=$lastday");

    print("$firstday ~ $lastday 급식메뉴: $uri");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    // 요청하기
    final Response response = await http.get(_uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }


  /// Lunch로 포장
  List<String> _lunchStringToList(String lunchMenus) {
    // 문자열 나누기
    List<String> foods = lunchMenus.split("<br/>");

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


      if(UserProfile.currentUser.schoolName=="도당고등학교"){
        cleanedData = cleanedData.replaceAll("1", "");
      }

      foods[i] = cleanedData;
    }

    return foods;
  }

  Map<String, Lunch> _lunches(Map<String, dynamic> json) {
    Map<String, Lunch> lunches = {}; // cleanMap["20211204"]= ["밥", "된장국", "딸기"]

    List? lunchMaps = json["mealServiceDietInfo"]?[1]?["row"];

    if (lunchMaps == null) {
      print("불러오지 못했습니다.");
    } else {
      for (Map map in lunchMaps) {
        String date = map["MLSV_YMD"];
        List<String> foods = _lunchStringToList(map["DDISH_NM"]);

        lunches[date] = Lunch(
          date: date,
          menu: foods,
        );
      }
    }

    return lunches;
  }


  /// 빈 곳 채워주기
  List<Lunch> _addBlankLunch(Map<String, Lunch> lunches) {
    // 빈자리를 채워주고 이름을 월, 일, 요일로 만들어준다.
    List<Lunch> boxes = [];

    final DateTime nowDateTime = DateTime.now();
    for (int index = FROM_TERM; index <= TO_TERM; index++) {
      // 날짜 구하기
      DateTime plusDateTime = nowDateTime.add(Duration(days: index));
      String day = DateFormat('yyyyMMdd').format(plusDateTime);

      // 이름 구하기
      String date = DateFormat('MM월 dd일 ').format(plusDateTime);
      String weekday = _weekdayEng2Kor(DateFormat('E').format(plusDateTime));
      String title = "$date $weekday";

      // 이름 바꾸기
      Lunch lunch = lunches[day] ?? Lunch(date: date, menu: ["급식정보가 없습니다."]);
      lunch.date = title;

      // 배열에 추가
      boxes.add(lunch);
    }

    return boxes;
  }

  String _weekdayEng2Kor(String weekEng) {
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
}
