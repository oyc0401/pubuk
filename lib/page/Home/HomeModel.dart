import 'package:flutter/cupertino.dart';
import '../../DB/userProfile.dart';
import 'Lunch/Lunch.dart';
import 'Lunch/GetLunch.dart';
import 'TimeTable/ClassData.dart';
import 'TimeTable/GetTable.dart';

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

    GetTable getTable = GetTable(userProfile);
    _classData = await getTable.getData();

    notifyListeners();
  }

  Future<void> setLunch(UserSchool userSchool) async {
    _changeProfile(userSchool);

    print("${userSchool.name} 급식 불러오는 중...");

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
