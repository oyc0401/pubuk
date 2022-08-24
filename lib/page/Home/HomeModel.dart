import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';

import '../../DB/userProfile.dart';
import 'Lunch/Lunch.dart';
import 'Lunch/NiceApi.dart';
import 'Lunch/lunchDown.dart';

class HomeModel with ChangeNotifier {
  HomeModel() {
    UserSchool userProfile = UserProfile.currentUser;
    setTimeTable(userProfile);
    setLunch(userProfile);
    _grade = userProfile.grade;
    _class = userProfile.Class;
    _name = userProfile.name;
  }

  late int _grade;
  late int _class;
  late String _name;

  Map<String, Lunch>? _lunchMap;
  ClassData? _classData;

  int get grade => _grade;

  int get Class => _class;

  String get name => _name;

  Map<String, Lunch>? get lunchMap => _lunchMap;

  ClassData? get classData => _classData;

  Future<void> setTimeTable(UserSchool userProfile) async {
    _changeProfile(userProfile);

    print("${userProfile.grade}학년 ${userProfile.Class}반 시간표 불러오는 중...");
    TableDownloader tabledown = TableDownloader(
      Grade: userProfile.grade,
      Class: userProfile.Class,
      SchoolCode: userProfile.code,
      CityCode: userProfile.officeCode,
      schoolLevel: userProfile.level,
    );
    await tabledown.downLoad();

    _classData = tabledown.getData();

    notifyListeners();
  }

  Future<void> setLunch(UserSchool userSchool) async {
    _changeProfile(userSchool);

    GetLunch getLunch = GetLunch(userSchool);
    _lunchMap = await getLunch.getLunch();

    notifyListeners();
  }

  _changeProfile(UserSchool userProfile) {
    _grade = userProfile.grade;
    _class = userProfile.Class;
    _name = userProfile.name;
  }
}

class GetLunch {
  GetLunch(UserSchool userSchool) : _userSchool = userSchool;

  final UserSchool _userSchool;

  Future<Map<String, Lunch>> getLunch() async {
    print("${_userSchool.name} 급식 불러오는 중...");

    LunchDownloader lunchDownload = LunchDownloader(
        code: _userSchool.code, officeCode: _userSchool.officeCode);
    var json = await lunchDownload.getJson(lunchDownload.uriPast);

    JsonToLunch jsonToLunch = JsonToLunch(json: json);

    Map<String, Lunch> _lunchMap = jsonToLunch.currentLunch(true);
    return _lunchMap;
  }
}
