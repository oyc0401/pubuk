import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';

import '../../DB/userProfile.dart';
import 'lunch.dart';

class HomeModel with ChangeNotifier {
  HomeModel() {
    init();
  }

  init() async {

    classData=await getData();
    lunches=await getLunch();
    notifyListeners();
  }

  Future<ClassData> getData() async {
    UserProfile userProfile = UserProfile.currentUser;

    TableDownloader tabledown = TableDownloader(
      Grade: userProfile.grade,
      Class: userProfile.Class,
      SchoolCode: userProfile.schoolCode,
      CityCode: userProfile.schoolLocalCode,
    );
    await tabledown.downLoad();

    ClassData dataBox = tabledown.getData();

    return dataBox;
  }

  Future<List<Lunch>> getLunch() async {
    UserProfile userData = UserProfile.currentUser;
    int schoolCode = userData.schoolCode;
    String cityCode = userData.schoolLocalCode;

    LunchDownloader lunchDownloader =
    LunchDownloader(SchoolCode: schoolCode, CityCode: cityCode);
    await lunchDownloader.downLoad();
    return lunchDownloader.getLunches();
  }



  List<Lunch>? lunches;
  ClassData? classData;


}
