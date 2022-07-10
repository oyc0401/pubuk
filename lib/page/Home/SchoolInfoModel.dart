import 'package:flutter/cupertino.dart';
import '../../DB/userProfile.dart';


class SchoolModel with ChangeNotifier {
  SchoolModel() {
    UserProfile userProfile = UserProfile.currentUser;
    grade = userProfile.grade;
    Class = userProfile.Class;
    schoolName = userProfile.schoolName;
    schoolLocalCode = userProfile.schoolLocalCode;
    schoolCode = userProfile.schoolCode;
  }

  late int grade;
  late int Class;
  late String schoolName;
  late String schoolLocalCode; // 학교 교육청 코드
  late int schoolCode; // 학교 코드

  setSchoolInfo(UserProfile userProfile) {
    grade = userProfile.grade;
    Class = userProfile.Class;
    schoolName = userProfile.schoolName;
    schoolLocalCode = userProfile.schoolLocalCode;
    schoolCode = userProfile.schoolCode;
    notifyListeners();
  }
}
