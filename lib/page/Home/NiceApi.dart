import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NiceApi {
  NiceApi({this.uri});

  Uri? uri;

  /// json 얻기
  Future<Map<String, dynamic>> parse() async {
    assert(uri != null, "uri 가 입력되지 않았습니다.");

    uri ??= Uri.parse("");

    // 요청하기
    final Response response = await http.get(uri!);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}

/// [NiceApi]를 상속하고 생성자에서 uri을 바꿔주면 사용 가능하다.

class LunchDownloader extends NiceApi {
  final int FROM_TERM = -30;
  final int TO_TERM = 30;

  String officeCode;
  int code;

  LunchDownloader({
    required this.officeCode,
    required this.code,
  }) {
    super.uri = _uriPast();
  }

  /// 처음 ~ 미래 30일
  Uri _uriPast() {
    const String firstDay = '20190401';

    DateTime now = DateTime.now();
    String lastDay =
    DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
            "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=$officeCode&SD_SCHUL_CODE=$code&"
            "MLSV_FROM_YMD=$firstDay&MLSV_TO_YMD=$lastDay");

    print("$firstDay ~ $lastDay 급식메뉴: $uri");
    return uri;
  }

  /// 과거 30일 ~ 미래 30일
  Uri get uri30 {
    DateTime now = DateTime.now();
    String firstDay =
    DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    String lastDay =
    DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
            "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=$officeCode&SD_SCHUL_CODE=$code&"
            "MLSV_FROM_YMD=$firstDay&MLSV_TO_YMD=$lastDay");

    print("$firstDay ~ $lastDay 급식메뉴: $uri");
    return uri;
  }
}

class TableDownload extends NiceApi {
  int grade;
  int Class;
  String officeCode;
  int code;
  int schoolLevel;

  TableDownload({
    required this.grade,
    required this.Class,
    required this.officeCode,
    required this.code,
    required this.schoolLevel,
  }) {
    super.uri = _weekUri();
  }



  Uri _weekUri() {
    var now = DateTime.now();
    var mon = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 1)));
    var fri = DateFormat('yyyyMMdd')
        .format(now.add(Duration(days: -1 * now.weekday + 5))); // weekday 금요일=5

    if (schoolLevel == 2) {
      return Uri.parse(
          "https://open.neis.go.kr/hub/misTimetable?Key=59b8af7c4312435989470cba41e5c7a6&Type=json&pIndex=1&pSize=1000&"
              "ATPT_OFCDC_SC_CODE=$officeCode&SD_SCHUL_CODE=$code&GRADE=$grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");
    } else {
      Uri uri = Uri.parse(
          "https://open.neis.go.kr/hub/hisTimetable?Key=59b8af7c4312435989470cba41e5c7a6&Type=json&pIndex=1&pSize=1000&"
              "ATPT_OFCDC_SC_CODE=$officeCode&SD_SCHUL_CODE=$code&GRADE=$grade&CLASS_NM=$Class&TI_FROM_YMD=$mon&TI_TO_YMD=$fri");
      return uri;
    }
  }

  @override
  Future<Map<String, dynamic>> parse() {
    print("$grade학년 $Class반 시간표 url: $uri");
    return super.parse();
  }
}


