import 'package:flutterschool/DB/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveKey {
  // set 하는것은 Instance가 필요 없지만
  // get 은 퓨처값을 주지 말아야 하기 때문에 Instance가 필요하다.
  late SharedPreferences prefs;

  static Instance() async {
    SaveKey key = SaveKey();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  /// set
  setGrade(int Grade) => prefs.setInt('Grade', Grade);

  setClass(int Class) => prefs.setInt('Class', Class);

  setCityCode(String CityCode) => prefs.setString("CityCode", CityCode);

  setSchoolCode(int SchoolCode) => prefs.setInt('SchoolCode', SchoolCode);

  setUid(String uid) => prefs.setString('ID', uid);

  setNickName(String nickname) => prefs.setString('Nickname', nickname);

  setAuthLevel(int auth) => prefs.setInt('AuthLevel', auth);

  setSchoolName(String name)=>prefs.setString('schoolName', name);
  setSchoolLevel(String level)=>prefs.setString('schoolLevel', level);

  /// get
  int getGrade() => prefs.getInt('Grade') ?? 1;

  int getClass() => prefs.getInt('Class') ?? 1;

  String getCityCode() => prefs.getString('CityCode') ?? "J10";

  int getSchoolCode() => prefs.getInt('SchoolCode') ?? 7530072;

  String getUid() => prefs.getString('ID') ?? '게스트id';

  String getNickName() => prefs.getString('Nickname') ?? '게스트';

  int getAuthLevel() => prefs.getInt('AuthLevel') ?? 1;

  String getSchoolName() => prefs.getString('schoolName') ?? "00고등학교";
  String getSchoolLevel() => prefs.getString('schoolLevel') ?? "고";

  UserProfile getUserProfile() {
    return UserProfile(
        uid: getUid(),
        nickname: getNickName(),
        authLevel: getAuthLevel(),
        grade: getGrade(),
        Class: getClass(),
        cityCode: getCityCode(),
        schoolCode: getSchoolCode(),
        schoolName: getSchoolName(),
    schoolLevel: "고");
  }

  setUserProfile(UserProfile UserProfile) {
    setUid(UserProfile.getUid());
    setNickName(UserProfile.getNickName());
    setAuthLevel(UserProfile.getAuth());
    setGrade(UserProfile.getGrade());
    setClass(UserProfile.getClass());
    setSchoolCode(UserProfile.getSchoolCode());
    print('saveKey: 유저 값 저장');
  }
}

class SaveKeyHandler extends SaveKey {
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
    setUid('게스트');
    setNickName('게스트');
    setAuthLevel(1);
    print('saveKey: 게스트가 되었습니다.');
  }
}
