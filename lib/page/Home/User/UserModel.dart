// import 'package:flutter/cupertino.dart';
//
// import '../../DB/userProfile.dart';
//
// class UserModel with ChangeNotifier {
//   // school
//   String schoolLocalCode; // 학교 교육청 코드
//   int schoolCode; // 학교 코드
//   String schoolName; // 학교 이름
//   int schoolLevel; // 1 = 초등학교, 2 = 중학교, 3 = 고등학교
//   int grade; // 학년
//   int Class; // 반
//
//   UserModel({
//     required this.grade,
//     required this.Class,
//     required this.schoolLocalCode,
//     required this.schoolName,
//     required this.schoolLevel,
//     required this.schoolCode,
//   });
//
//   static UserModel fromDB(UserProfile userProfile) {
//     return UserModel(
//       grade: userProfile.grade,
//       Class: userProfile.Class,
//       schoolName: userProfile.schoolName,
//       schoolCode: userProfile.schoolCode,
//       schoolLevel: userProfile.schoolLevel,
//       schoolLocalCode: userProfile.schoolLocalCode,
//     );
//   }
//
//
// }
