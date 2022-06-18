import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';

import '../../DB/userProfile.dart';
import 'lunch.dart';

class HomeModel with ChangeNotifier {
  HomeModel() {
    setClass();
    setLunch();
  }

  List<Lunch>? lunches;
  ClassData? classData;

  Future<void> setClass() async {
    UserProfile userProfile = UserProfile.currentUser;

    print("${userProfile.grade}학년 ${userProfile.Class}반 시간표 불러오는 중...");
    TableDownloader tabledown = TableDownloader(
      Grade: userProfile.grade,
      Class: userProfile.Class,
      SchoolCode: userProfile.schoolCode,
      CityCode: userProfile.schoolLocalCode,
    );
    await tabledown.downLoad();

    classData = tabledown.getData();

    notifyListeners();
  }

  Future<void> setLunch() async {
    UserProfile userProfile = UserProfile.currentUser;

    print("${userProfile.schoolName} 급식 불러오는 중...");
    LunchDownloader lunchDownloader = LunchDownloader(
      schoolCode: userProfile.schoolCode,
      cityCode: userProfile.schoolLocalCode,
    );
    await lunchDownloader.downLoad();

    lunches = lunchDownloader.getLunches();
    notifyListeners();
  }
}
