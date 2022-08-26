import '../../../DB/userProfile.dart';
import 'Lunch.dart';
import '../NiceApi.dart';

class GetLunch {
  GetLunch(UserSchool userSchool) : _userSchool = userSchool;

  final UserSchool _userSchool;

  Future<Map<String, Lunch>> getLunch() async {
    /// json 가져오고
    LunchDownloader lunchDownload = LunchDownloader(
        code: _userSchool.code, officeCode: _userSchool.officeCode);
    Map<String, dynamic> json = await lunchDownload.parse();

    /// 그걸 Lunch에 넣는다.
    return _currentLunch(json);
  }

  /// Map에 현재 얻어올 수 있는 급식을 날짜대로 저장하고
  Map<String, Lunch> _currentLunch(Map<String, dynamic> json) {
    Map<String, Lunch> lunches = {}; // cleanMap["20211204"]= ["밥", "된장국", "딸기"]

    List? lunchMaps = json["mealServiceDietInfo"]?[1]?["row"];

    if (lunchMaps == null) {
      print("불러오지 못했습니다.");
    } else {
      for (Map map in lunchMaps) {
        String date = map["MLSV_YMD"];
        lunches[date] = _mapToLunch(map);
      }
    }

    return lunches;
  }

  Lunch _mapToLunch(Map map) {
    List<String> splitList(String text) => text.split("<br/>");

    String date = map["MLSV_YMD"];
    String dish = map["DDISH_NM"];
    String origin = map["ORPLC_INFO"] ?? "";
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
