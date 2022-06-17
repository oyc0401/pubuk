import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';

import '../../DB/userProfile.dart';
import 'lunch.dart';

class HomeModel with ChangeNotifier {
  HomeModel() {
    UserProfile userProfile = UserProfile.currentUser;

    setClass(userProfile);
    setLunch(userProfile);
  }

  List<Lunch>? lunches;
  ClassData? classData;

  Future<void> setClass(UserProfile userProfile) async {
    print("${userProfile.grade}학년 ${userProfile.Class}반 시간표 불러오는중...");
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

  Future<void> setLunch(UserProfile userProfile) async {
    print("${userProfile.schoolName} 급식 불러오는중...");
    LunchDownloader lunchDownloader = LunchDownloader(
      SchoolCode: userProfile.schoolCode,
      CityCode: userProfile.schoolLocalCode,
    );
    await lunchDownloader.downLoad();

    lunches = lunchDownloader.getLunches();
    notifyListeners();
  }
}
