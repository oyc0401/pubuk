import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NiceApi {
  NiceApi();

  /// json 얻기
  Future<Map<String, dynamic>> parse(Uri uri) async {
    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class LunchDownloader extends NiceApi {
  final int FROM_TERM = -30;
  final int TO_TERM = 30;

  String officeCode;
  int code;

  LunchDownloader({
    required this.officeCode,
    required this.code,
  });

  /// nice API url
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

  /// nice API url
  Uri get uriPast {
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
}

