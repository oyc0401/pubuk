import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';

import '../../DB/userProfile.dart';
import 'Lunch/Lunch.dart';
import 'Lunch/lunchListView.dart';

class HomeModel with ChangeNotifier {
  HomeModel() {
    UserSchool userProfile = UserProfile.currentUser;
    setTimeTable(userProfile);
    setLunch(userProfile);
    grade=userProfile.grade;
    Class=userProfile.Class;
    schoolName=userProfile.name;
  }

  late int grade;
  late int Class;
  late String schoolName;

  List<Lunch>? lunches;
  ClassData? classData;

  Future<void> setTimeTable(UserSchool userProfile) async {
    grade=userProfile.grade;
    Class=userProfile.Class;
    schoolName=userProfile.name;

    print("${userProfile.grade}학년 ${userProfile.Class}반 시간표 불러오는 중...");
    TableDownloader tabledown = TableDownloader(
      Grade: userProfile.grade,
      Class: userProfile.Class,
      SchoolCode: userProfile.code,
      CityCode: userProfile.officeCode,
      schoolLevel: userProfile.level,
    );
    await tabledown.downLoad();

    classData = tabledown.getData();

    notifyListeners();
  }

  Future<void> setLunch(UserSchool userProfile) async {
    grade=userProfile.grade;
    Class=userProfile.Class;
    schoolName=userProfile.name;

    print("${userProfile.name} 급식 불러오는 중...");
    LunchDownloader lunchDownloader = LunchDownloader(
      schoolCode: userProfile.code,
      cityCode: userProfile.officeCode,
    );
    await lunchDownloader.downLoad();

    lunches = lunchDownloader.getLunches();
    notifyListeners();
  }
}
