import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  // user
  String uid; // 유저 id
  String nickname; // 닉네임
  int authLevel; // 자신의 권한 1 = user, 2= teacher, 3 = parents, 10 = master
  String provider; // 로그인 환경
  // school
  String schoolLocalCode; // 학교 교육청 코드
  int schoolCode; // 학교 코드
  String schoolName; // 학교 이름
  int schoolLevel; // 1 = 초등학교, 2 = 중학교, 3 = 고등학교
  int grade; // 학년
  int Class; // 반
  String certifiedSchoolCode; // 인증 받은 학교 코드

  UserProfile(
      {this.uid = 'guest',
      this.nickname = '',
      this.authLevel = 1,
      this.provider = "",
      this.grade = 1,
      this.Class = 1,
      this.schoolLocalCode = "J10",
      this.schoolName = "부천북고등학교",
      this.schoolLevel = 3,
      this.schoolCode = 7530072,
      this.certifiedSchoolCode = "null"});

  static UserProfile? _current;

  static initializeUser() async {
    SavePro savePro = await SavePro.Instance();
    _current = savePro.getUserProfile();
  }

  static UserProfile get currentUser {
    if (_current != null) {
      return _current!;
    } else {
      print("Warning: 유저 초기화가 필요합니다.");
      return _current!;
    }
  }

  static Future<void> save(UserProfile userProfile) async {
    _current = userProfile;
    print("static User update");
    SavePro savePro = await SavePro.Instance();
    savePro.setUserProfile(userProfile);
  }

  factory UserProfile.guest() {
    return UserProfile(
      uid: 'guest',
      nickname: 'guest',
      authLevel: 1,
    );
  }

  factory UserProfile.FirebaseUser(Map map) {
    return UserProfile(
      uid: map['uid'],
      authLevel: map['authLevel'],
      Class: map['class'],
      grade: map['grade'],
      provider: map['provider'],
      nickname: map['nickname'],
      schoolLocalCode: map['schoolLocalCode'],
      schoolName: map['schoolName'],
      schoolCode: map['schoolCode'],
      schoolLevel: map['schoolLevel'],
      certifiedSchoolCode: map['certifiedSchoolCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'authLevel': authLevel,
      'class': Class,
      'grade': grade,
      'provider': provider,
      'nickname': nickname,
      'schoolLocalCode': schoolLocalCode,
      'schoolName': schoolName,
      'schoolCode': schoolCode,
      'schoolLevel': schoolLevel,
      'certifiedSchoolCode': certifiedSchoolCode,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class UserProfileHandler extends UserProfile {
  static SwitchGuest() {
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

  /// _get
  int _getGrade() => prefs.getInt('Grade') ?? userProfile.grade;

  int _getClass() => prefs.getInt('Class') ?? userProfile.Class;

  String _getSchoolLocalCode() =>
      prefs.getString('schoolLocalCode') ?? userProfile.schoolLocalCode;

  int _getSchoolCode() => prefs.getInt('SchoolCode') ?? userProfile.schoolCode;

  String _getUid() => prefs.getString('ID') ?? userProfile.uid;

  String _getNickName() => prefs.getString('Nickname') ?? userProfile.nickname;

  int _getAuthLevel() => prefs.getInt('AuthLevel') ?? userProfile.authLevel;

  String _getSchoolName() =>
      prefs.getString('schoolName') ?? userProfile.schoolName;

  int _getSchoolLevel() =>
      prefs.getInt('schoolLevel') ?? userProfile.schoolLevel;

  String _getCertifiedSchoolCode() =>
      prefs.getString('certifiedSchoolCode') ?? userProfile.certifiedSchoolCode;

  String _getProvider() => prefs.getString('provider') ?? userProfile.provider;

  UserProfile getUserProfile() {
    return UserProfile(
        uid: _getUid(),
        nickname: _getNickName(),
        authLevel: _getAuthLevel(),
        provider: _getProvider(),
        grade: _getGrade(),
        Class: _getClass(),
        schoolLocalCode: _getSchoolLocalCode(),
        schoolCode: _getSchoolCode(),
        schoolName: _getSchoolName(),
        schoolLevel: _getSchoolLevel(),
        certifiedSchoolCode: _getCertifiedSchoolCode());
  }

  setUserProfile(UserProfile userProfile) {
    _setUid(userProfile.uid);
    _setNickName(userProfile.nickname);
    _setAuthLevel(userProfile.authLevel);
    _setProvider(userProfile.provider);
    _setGrade(userProfile.grade);
    _setClass(userProfile.Class);
    _setSchoolCode(userProfile.schoolCode);
    print('Local DB: 유저 저장');
  }
}
