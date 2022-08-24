import 'Lunch.dart';

class LunchMaker {
  LunchMaker({required this.json});

  Map<String, dynamic> json;

  /// Map에 현재 얻어올 수 있는 급식을 날짜대로 저장하고
  Map<String, Lunch> currentLunch(bool isHttp) {
    Map<String, Lunch> lunches = {}; // cleanMap["20211204"]= ["밥", "된장국", "딸기"]

    List? lunchMaps = json["mealServiceDietInfo"]?[1]?["row"];

    if (lunchMaps == null) {
      print("불러오지 못했습니다.");
    } else {
      for (Map map in lunchMaps) {
        String date = map["MLSV_YMD"];
        lunches[date] = _mapToLunch(map, isHttp);
      }
    }

    return lunches;
  }

  Lunch _mapToLunch(Map map, bool isHttp) {
    List<String> splitList(String text) =>
        isHttp ? text.split("<br/>") : text.split(" ");

    String date = map["MLSV_YMD"];
    String dish = map["DDISH_NM"];
    String origin = map["ORPLC_INFO"];
    String calorie = map["CAL_INFO"];
    String nutrient = map["NTR_INFO"];

    return Lunch(
      YMD: date,
      dish: splitList(dish),
      origin: splitList(origin),
      calorie: calorie,
      nutrient: splitList(nutrient),
    );
  }
}
