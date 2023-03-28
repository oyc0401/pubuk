import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:provider/provider.dart';

import '../../Server/FireTool.dart';
import '../../Server/FirebaseAirPort.dart';
import '../Home/HomeModel.dart';

class EditProfileModel  with ChangeNotifier {
  EditProfileModel({required this.grade,
    required this.Class,
    required this.schoolName,
    required this.schoolCode,
    required this.schoolLevel,
    required this.schoolLocalCode}) {}

  static EditProfileModel fromDB(UserSchool userProfile) {
    return EditProfileModel(
      grade: userProfile.grade,
      Class: userProfile.Class,
      schoolName: userProfile.name,
      schoolCode: userProfile.code,
      schoolLevel: userProfile.level,
      schoolLocalCode: userProfile.officeCode,
    );
  }

  void reset() {
    print("리셋: ${UserProfile.currentUser}");
    UserSchool pro = UserProfile.currentUser;
    grade = pro.grade;
    Class = pro.Class;
    schoolName = pro.name;
    schoolCode = pro.code;
    schoolLevel = pro.level;
    schoolLocalCode = pro.officeCode;
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
      case HighSchool.dodangH:
        schoolName = "도당고등학교";
        schoolCode = 7530471;
        schoolLevel = 3;
        schoolLocalCode = "J10";
        break;
      case HighSchool.dodangM:
        schoolName = "도당중학교";
        schoolCode = 7581267;
        schoolLevel = 2;
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
    UserSchool user = UserProfile.currentUser;
    user.grade = grade;
    user.Class = Class;
    user.name = schoolName;
    user.code = schoolCode;
    user.level = schoolLevel;
    user.officeCode = schoolLocalCode;
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
  dodangH,
  dodangM,
}
