import 'package:flutterschool/Server/FirebaseAirPort.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends MapContainer{
  /// DB 더 추가하려면 17개의 인자를 추가해야함
  /// UserProfile: 필드, 생성자 [UserProfile], 파이어베이스 전달 함수 [UserProfile.fromMap], toMap 함수 [toMap]
  /// DataBase: DB 저장함수, DB 불러오기 함수, UserProfile 받아서 저장하기 함수
  /// Firebase Storage 직접 추가
  ///


  // school
  String schoolLocalCode; // 학교 교육청 코드
  int schoolCode; // 학교 코드
  String schoolName; // 학교 이름
  int schoolLevel; // 1 = 초등학교, 2 = 중학교, 3 = 고등학교
  int grade; // 학년
  int Class; // 반


  UserProfile(
      {
      this.grade = 1,
      this.Class = 1,
      this.schoolLocalCode = "J10", // 북고만 서비스 할거면 필요없음
      this.schoolName = "부천북고등학교", // 북고만 서비스 할거면 필요없음
      this.schoolLevel = 3, // 북고만 서비스 할거면 필요없음
      this.schoolCode = 7530072, // 북고만 서비스 할거면 필요없음
      });

  static UserProfile? _current;

  static initializeUser() async {
    SavePro savePro = await SavePro.Instance();
    _current = savePro.getUserProfile();
  }

  static UserProfile get currentUser {
    assert(_current != null, "Warning: 유저 초기화가 필요합니다.");
    return _current!;
  }

  static Future<void> save(UserProfile userProfile) async {
    _current = userProfile;
    print("static User update");
    SavePro savePro = await SavePro.Instance();
    savePro.setUserProfile(userProfile);
  }

  static UserProfile guest() {
    UserProfile userProfile = UserProfile.currentUser;

    return UserProfile(
      grade: userProfile.grade,
      Class: userProfile.Class,
    );
  }

  static UserProfile fromMap(Map map) {
    UserProfile user = UserProfile();
    return UserProfile(

      Class: map['class'] ?? user.Class,
      grade: map['grade'] ?? user.grade,

      schoolLocalCode: map['schoolLocalCode'] ?? user.schoolLocalCode,
      schoolName: map['schoolName'] ?? user.schoolName,
      schoolCode: map['schoolCode'] ?? user.schoolCode,
      schoolLevel: map['schoolLevel'] ?? user.schoolLevel,

    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {

      'class': Class,
      'grade': grade,

      'schoolLocalCode': schoolLocalCode,
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolLevel': schoolLevel,

    };
  }

  @override
  String toString() => toMap().toString();
}

class UserProfileHandler extends UserProfile {
  UserProfileHandler.SwitchGuest() {
    print("Local DB 게스트 상태로 변경");
    UserProfile userProfile = UserProfile.guest();
    UserProfile.save(userProfile);
  }
}

class SavePro {
  // _set 하는것은 Instance가 필요 없지만
  // _get 은 퓨처값을 주지 말아야 하기 때문에 Instance가 필요하다.
  late SharedPreferences prefs;

  static Instance() async {
    SavePro key = SavePro();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  UserProfile userProfile = UserProfile();

  /// _set
  _setGrade(int Grade) => prefs.setInt('Grade', Grade);

  _setClass(int Class) => prefs.setInt('Class', Class);

  _setCityCode(String CityCode) => prefs.setString("CityCode", CityCode);

  _setSchoolCode(int SchoolCode) => prefs.setInt('SchoolCode', SchoolCode);

  _setUid(String uid) => prefs.setString('ID', uid);

  _setNickName(String nickname) => prefs.setString('Nickname', nickname);

  _setAuthLevel(int auth) => prefs.setInt('AuthLevel', auth);

  _setSchoolName(String name) => prefs.setString('schoolName', name);

  _setSchoolLevel(int level) => prefs.setInt('schoolLevel', level);

  _setCertifiedSchoolCode(String certified) =>
      prefs.setString('certifiedSchoolCode', certified);

  _setProvider(String provider) => prefs.setString('provider', provider);

  _setAuthId(String authId) => prefs.setString('authId', authId);

  /// _get
  int _getGrade() => prefs.getInt('Grade') ?? userProfile.grade;

  int _getClass() => prefs.getInt('Class') ?? userProfile.Class;

  String _getSchoolLocalCode() =>
      prefs.getString('schoolLocalCode') ?? userProfile.schoolLocalCode;

  int _getSchoolCode() => prefs.getInt('SchoolCode') ?? userProfile.schoolCode;



  String _getSchoolName() =>
      prefs.getString('schoolName') ?? userProfile.schoolName;

  int _getSchoolLevel() =>
      prefs.getInt('schoolLevel') ?? userProfile.schoolLevel;



  UserProfile getUserProfile() {
    return UserProfile(

        grade: _getGrade(),
        Class: _getClass(),
        schoolLocalCode: _getSchoolLocalCode(),
        schoolCode: _getSchoolCode(),
        schoolName: _getSchoolName(),
        schoolLevel: _getSchoolLevel(),
       );
  }

  setUserProfile(UserProfile userProfile) {
    _setGrade(userProfile.grade);
    _setClass(userProfile.Class);
    _setSchoolCode(userProfile.schoolCode);
    _setSchoolName(userProfile.schoolName);
    print('Local DB: 유저 저장');
  }
}
