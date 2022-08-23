import 'dart:convert';

import 'package:flutterschool/Server/FirebaseAirPort.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Lunch {
  /// 하루의 점심 정보를 담고있는 객체

  String YMD;
  List<String> dish;
  List<String> origin;
  String calorie;
  List<String> nutrient;

  Lunch({
    required this.YMD,
    required this.dish,
    required this.origin,
    required this.calorie,
    required this.nutrient,
  });

  List<String> get menu {
    if (dish.isEmpty) {
      return ["급식정보가 없습니다."];
    }

    return List.generate(dish.length, (index) => LunchText.cleanText(dish[index]));
  }

  String get date {
    if (YMD == "") {
      return "";
    }
    DateTime dateTime = DateTime.parse(YMD);

    // 이름 구하기
    String st = DateFormat('MM월 dd일').format(dateTime);
    String weekday = DateFormat('E', 'ko').format(dateTime);
    String title = "$st $weekday요일";

    return title;
  }

  factory Lunch.mapToLunch(Map map,bool isHttp) {
    List<String> splitList(String text) {

      List<String> foods=[];
      if(isHttp){
        // 문자열 나누기
         foods = text.split("<br/>");
      }else{
        // 문자열 나누기
         foods = text.split(" ");
      }

      return foods;
    }

    String date = map["MLSV_YMD"];
    String dish = map["DDISH_NM"];
    String orplc = map["ORPLC_INFO"];
    String cal = map["CAL_INFO"];
    String nutrient = map["NTR_INFO"];

    return Lunch(
      YMD: date,
      dish: splitList(dish),
      origin: splitList(orplc),
      calorie: cal,
      nutrient: splitList(nutrient),
    );
  }

  factory Lunch.noData(String date) {
    return Lunch(
      YMD: date,
      dish: [],
      origin: [],
      nutrient: [],
      calorie: "",
    );
  }

  factory Lunch.blank() {
    return Lunch(
      YMD: "",
      dish: List.generate(6, (index) => ""),
      origin: [],
      nutrient: [],
      calorie: "",
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "menu": menu,
      "origin": origin,
      "calorie": calorie,
      "nutrient": nutrient,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}


class LunchText{
  static  cleanText(String text){
    String cleanedData = text.replaceAll("북고", "");

    for (int k = 20; k > 0; k--) {
      cleanedData = cleanedData.replaceAll("$k.", "");
    }

    cleanedData = cleanedData.replaceAll("-", "");
    cleanedData = cleanedData.replaceAll("_", "");
    cleanedData = cleanedData.replaceAll("()", "");

    cleanedData = cleanedData.replaceAll(" ", "");

    // if (UserProfile.currentUser.schoolName == "도당고등학교") {
    //   cleanedData = cleanedData.replaceAll("1", "");
    // }
    cleanedData = cleanedData.replaceAll("1 ", "");

    return cleanedData;
  }
}

const int FROM_TERM = -30;
const int TO_TERM = 30;

class LunchDownload {
  int schoolCode;
  String cityCode;

  LunchDownload({
    required this.cityCode,
    required this.schoolCode,
  });

  /// nice API url
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

  /// json 얻기
  Future<Map<String, dynamic>> getJson() async {
    // 요청하기
    final Response response = await http.get(_uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class JsonToLunch {
  JsonToLunch({required this.json});
  Map<String, dynamic> json;

  List<Lunch> getLunches() => _addBlankLunch(currentLunch(true));

  /// Map에 현재 얻어올 수 있는 급식을 날짜대로 저장하고
  Map<String, Lunch> currentLunch(bool isHttp) {
    Map<String, Lunch> lunches = {}; // cleanMap["20211204"]= ["밥", "된장국", "딸기"]

    List? lunchMaps = json["mealServiceDietInfo"]?[1]?["row"];

    if (lunchMaps == null) {
      print("불러오지 못했습니다.");
    } else {
      for (Map map in lunchMaps) {
        String date = map["MLSV_YMD"];
        lunches[date] = Lunch.mapToLunch(map,isHttp);
      }
    }

    return lunches;
  }

  /// 일정 기간 이내에서 Map에 급식이 없으면 빈 모델을 리스트에 넣는다.
  List<Lunch> _addBlankLunch(Map<String, Lunch> lunches) {
    // 빈자리를 채워주고 이름을 월, 일, 요일로 만들어준다.
    List<Lunch> boxes = [];

    final DateTime nowDateTime = DateTime.now();
    for (int index = FROM_TERM; index <= TO_TERM; index++) {
      // 날짜 구하기
      DateTime plusDateTime = nowDateTime.add(Duration(days: index));
      String day = DateFormat('yyyyMMdd').format(plusDateTime);

      // 배열에 추가
      boxes.add(lunches[day] ?? Lunch.noData(day));
    }

    return boxes;
  }
}
