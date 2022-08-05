import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:provider/provider.dart';

import '../../Server/FireTool.dart';
import '../../Server/FirebaseAirPort.dart';
import '../Home/HomeModel.dart';

class EditProfileModel extends MapContainer with ChangeNotifier {
  EditProfileModel({required this.grade,
    required this.Class,
    required this.schoolName,
    required this.schoolCode,
    required this.schoolLevel,
    required this.schoolLocalCode}) {}

  static EditProfileModel fromDB(UserProfile userProfile) {
    return EditProfileModel(
      grade: userProfile.grade,
      Class: userProfile.Class,
      schoolName: userProfile.schoolName,
      schoolCode: userProfile.schoolCode,
      schoolLevel: userProfile.schoolLevel,
      schoolLocalCode: userProfile.schoolLocalCode,
    );
  }

  void reset() {
    print("리셋: ${UserProfile.currentUser}");
    UserProfile pro = UserProfile.currentUser;
    grade = pro.grade;
    Class = pro.Class;
    schoolName = pro.schoolName;
    schoolCode = pro.schoolCode;
    schoolLevel = pro.schoolLevel;
    schoolLocalCode = pro.schoolLocalCode;
  }

  int grade;
  int Class;
  String schoolName;
  int schoolCode;
  int schoolLevel;
  String schoolLocalCode;

  setHighSchool(HighSchool school) {
    switch (school) {
      case HighSchool.pubuk:
        schoolName = "부천북고등학교";
        schoolCode = 7530072;
        schoolLevel = 3;
        schoolLocalCode = "J10";
        break;
      case HighSchool.dodang:
        schoolName = "도당고등학교";
        schoolCode = 7530471;
        schoolLevel = 3;
        schoolLocalCode = "J10";
        break;
      case HighSchool.wonjong:
        schoolName = "원종고등학교";
        schoolCode = 7530107;
        schoolLevel = 3;
        schoolLocalCode = "J10";
        break;
    }
    notifyListeners();
  }

  setGrade(int gra) {
    grade = gra;
    notifyListeners();
  }

  setClass(int cla) {
    Class = cla;
    notifyListeners();
  }

  Future<void> saveLocal() async {
    UserProfile user = UserProfile.currentUser;
    user.grade = grade;
    user.Class = Class;
    user.schoolName = schoolName;
    user.schoolCode = schoolCode;
    user.schoolLevel = schoolLevel;
    user.schoolLocalCode = schoolLocalCode;
    // 로컬 DB에 저장

    await UserProfile.save(user);
    print("로컬 DB 저장 완료");
  }

  // Future<void> saveFireBase() async {
  //   UserProfile userData = UserProfile.currentUser;
  //   switch (userData.provider) {
  //     case "Google":
  //     case "Apple":
  //     case "Kakao":
  //     // firebase DB에 저장
  //       print("현재 로그인 상태입니다.");
  //       FirebaseAirPort fireUser = FirebaseAirPort(uid: userData.uid);
  //       await fireUser.update(
  //           EditProfileModel(
  //             grade: grade,
  //             Class: Class,
  //             schoolName: schoolName,
  //             schoolCode: schoolCode,
  //             schoolLevel: schoolLevel,
  //             schoolLocalCode: schoolLocalCode,
  //           )
  //       );
  //       print("firebase 저장 완료");
  //       break;
  //   }
  // }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      'grade': grade,
      'class': Class,
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolLevel': schoolLevel,
      'schoolLocalCode': schoolLocalCode,
    };
  }
}

enum HighSchool {
  pubuk,
  dodang,
  wonjong,
}
