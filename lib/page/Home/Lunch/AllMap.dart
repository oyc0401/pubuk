import '../../../DB/userProfile.dart';
import 'Lunch.dart';

class LunchAllMap {


  static Future<Map<String, List<String>>> assetMap() async {
    Map<String, List<String>> allMap =
        {}; // ["급식이름"][20210819, 20210910, 20211005, 20211108];

    LunchDownload lunchDownload = LunchDownload(
      schoolCode: UserProfile.currentUser.code,
      cityCode: UserProfile.currentUser.officeCode,
    );
    Map<String, dynamic> json =
        await lunchDownload.getJson(lunchDownload.uriPast);
    JsonToLunch jsonToLunch = JsonToLunch(json: json);
    Map<String, Lunch> lunchmaps = jsonToLunch.currentLunch(true);

    lunchmaps.forEach((date, lunch) {
      for (var dish in lunch.menu) {
        if (allMap[dish] == null) {
          allMap[dish] = [date];
        } else {
          allMap[dish]!.add(date);
        }
      }
    });

    print(allMap);

    return allMap;
  }
}
