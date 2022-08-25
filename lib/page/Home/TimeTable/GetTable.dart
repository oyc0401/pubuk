import 'package:flutterschool/DB/userProfile.dart';
import 'package:intl/intl.dart';

import '../NiceApi.dart';
import 'ClassData.dart';

class GetTable {
  GetTable(this.userProfile);

  UserSchool userProfile;

  Future<ClassData> getData() async {
    TableDownload tableDownload = TableDownload(
      grade: userProfile.grade,
      Class: userProfile.Class,
      code: userProfile.code,
      officeCode: userProfile.officeCode,
      schoolLevel: userProfile.level,
    );
    Map<String, dynamic> Json = await tableDownload.parse();

    return _classDataFromJson(Json);
  }

  ClassData _classDataFromJson(Map<String, dynamic> json) {
    // 각 요일의 날짜를 구하기
    final DateTime now = DateTime.now();
    List<String> dates =
        []; // dates: [20220613, 20220614, 20220615, 20220616, 20220617]
    for (int i = 1; i <= 5; i++) {
      dates.add(DateFormat('yyyyMMdd')
          .format(now.add(Duration(days: -1 * now.weekday + i))));
    }

    // 과목이 담길 리스트를 만든다
    List<String> arrMon = [],
        arrTue = [],
        arrWed = [],
        arrThu = [],
        arrFri = [];

    // 이 리스트는 시간 맵이 모두 들어있는 리스트
    List? TimeList = json['hisTimetable']?[1]?['row'];

    if (TimeList == null) {
      assert(json["RESULT"]?["MESSAGE"] == "해당하는 데이터가 없습니다.",
          "시간표 url을 불러오는 과정에서 예상치 못한 오류가 발생했습니다.");
      String message = "데이터가 없습니다.";
      arrMon.add(message);
      arrTue.add(message);
      arrWed.add(message);
      arrThu.add(message);
      arrFri.add(message);
    } else {
      assert(json['hisTimetable']?[0]?['head']?[1]?['RESULT']?['MESSAGE'] ==
          "정상 처리되었습니다.");

      for (int i = 0; i < TimeList.length; i++) {
        final String date = TimeList[i]['ALL_TI_YMD'];
        final String subject = TimeList[i]['ITRT_CNTNT'];

        if (date == dates[0]) {
          arrMon.add(subject);
        } else if (date == dates[1]) {
          arrTue.add(subject);
        } else if (date == dates[2]) {
          arrWed.add(subject);
        } else if (date == dates[3]) {
          arrThu.add(subject);
        } else if (date == dates[4]) {
          arrFri.add(subject);
        }
      }
    }

    return ClassData(
        Mon: arrMon, Tue: arrTue, Wed: arrWed, Thu: arrThu, Fri: arrFri);
  }
}
