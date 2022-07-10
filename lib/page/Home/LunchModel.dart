import 'package:flutter/cupertino.dart';
import 'package:flutterschool/page/Home/timetable.dart';
import 'lunch.dart';

class LunchModel with ChangeNotifier {
  LunchModel({
    this.schoolLocalCode,
    this.schoolCode,
    this.grade,
    this.Class,
    this.schoolName,
  }) {
    if (schoolCode != null) {
      _setClass();
      _setLunch();
    }
    print("saㄴㅁsa");
  }

  List<Lunch>? lunches;
  ClassData? classData;

  int? grade;
  int? Class;
  int? schoolCode;
  String? schoolLocalCode;
  String? schoolName;

  Future<void> _setClass() async {
    print("$grade학년 $Class반 시간표 불러오는 중...");
    TableDownloader tabledown = TableDownloader(
      Grade: grade!,
      Class: Class!,
      SchoolCode: schoolCode!,
      CityCode: schoolLocalCode!,
    );
    await tabledown.downLoad();

    classData = tabledown.getData();

    notifyListeners();
  }

  Future<void> _setLunch() async {
    print("$schoolName 급식 불러오는 중...");
    LunchDownloader lunchDownloader = LunchDownloader(
      schoolCode: schoolCode!,
      cityCode: schoolLocalCode!,
    );
    await lunchDownloader.downLoad();

    lunches = lunchDownloader.getLunches();
    notifyListeners();
  }
}
