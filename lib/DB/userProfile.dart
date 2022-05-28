import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  String uid; // 유저 id
  String nickname; // 닉네임
  int authLevel; // 자신의 권한 1 = user, 2= teacher, 3 = parents, 10 = master

  // need to make school

  String schoolLocalCode; // 학교 교육청 코드
  int schoolCode; // 학교 코드
  String schoolName; // 학교 이름
  int schoolLevel; // 1 = 초등학교, 2 = 중학교, 3 = 고등학교
  int grade; // 학년
  int Class; // 반
  String certifiedSchoolCode; // 인증 받은 학교 코드

  UserProfile(
      {this.uid = '',
      this.nickname = '',
      this.authLevel = 1,
      this.grade = 1,
      this.Class = 1,
      this.schoolLocalCode = "J10",
      this.schoolName = "부천북고등학교",
      this.schoolLevel = 3,
      this.schoolCode = 7530072,
      this.certifiedSchoolCode = "null"});

  static Future<void> Save(UserProfile userProfile) async {
    SavePro savePro = await SavePro.Instance();
    await savePro.setUserProfile(userProfile);
  }

  static Future<UserProfile> Get() async {
    SavePro savePro = await SavePro.Instance();
    return  savePro.getUserProfile();
  }



  factory UserProfile.guestData() {
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
      nickname: map['nickname'],
      schoolLocalCode: map['schoolLocalCode'],
      schoolName: map['schoolName'],
      schoolCode: map['schoolCode'],
      schoolLevel: map['schoolLevel'],
      certifiedSchoolCode: map['certifiedSchoolCode'],
    );
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

  UserProfile userProfile=UserProfile();

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

  /// _get
  int _getGrade() => prefs.getInt('Grade') ?? userProfile.grade;

  int _getClass() => prefs.getInt('Class') ?? userProfile.Class;

  String _getSchoolLocalCode() => prefs.getString('schoolLocalCode') ?? userProfile.schoolLocalCode;

  int _getSchoolCode() => prefs.getInt('SchoolCode') ?? userProfile.schoolCode;

  String _getUid() => prefs.getString('ID') ?? userProfile.uid;

  String _getNickName() => prefs.getString('Nickname') ?? userProfile.nickname;

  int _getAuthLevel() => prefs.getInt('AuthLevel') ?? userProfile.authLevel;

  String _getSchoolName() => prefs.getString('schoolName') ?? userProfile.schoolName;

  int _getSchoolLevel() => prefs.getInt('schoolLevel') ?? userProfile.schoolLevel;

  String _getCertifiedSchoolCode() => prefs.getString('certifiedSchoolCode') ?? userProfile.certifiedSchoolCode;

  UserProfile getUserProfile() {
    return UserProfile(
        uid: _getUid(),
        nickname: _getNickName(),
        authLevel: _getAuthLevel(),
        grade: _getGrade(),
        Class: _getClass(),
        schoolLocalCode: _getSchoolLocalCode(),
        schoolCode: _getSchoolCode(),
        schoolName: _getSchoolName(),
        schoolLevel: 3,
        certifiedSchoolCode: "null");
  }

  setUserProfile(UserProfile UserProfile) {
    _setUid(UserProfile.uid);
    _setNickName(UserProfile.nickname);
    _setAuthLevel(UserProfile.authLevel);
    _setGrade(UserProfile.grade);
    _setClass(UserProfile.Class);
    _setSchoolCode(UserProfile.schoolCode);
    print('saveKey: 유저 값 저장');
  }
}

class SaveKeyHandler extends SavePro {
  static Instance() async {
    SaveKeyHandler key = SaveKeyHandler();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  printAll() {
    print(prefs.getKeys());
    print(prefs.get('ID'));
    print(prefs.get('SchoolCode'));
    print(prefs.get('Grade'));
    print(prefs.get('Class'));
    print(prefs.get('Nickname'));
    print(prefs.get('Auth'));
  }

  void SwitchGuest() {
    _setUid('게스트');
    _setNickName('게스트');
    _setAuthLevel(1);
    print('saveKey: 게스트가 되었습니다.');
  }
}
