import 'package:shared_preferences/shared_preferences.dart';

import 'UserData.dart';

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

  setCityCode(String CityCode)=>prefs.setString("CityCode", CityCode);

  setSchoolCode(int SchoolCode) => prefs.setInt('SchoolCode', SchoolCode);

  setUid(String uid) => prefs.setString('ID', uid);

  setNickName(String nickname) => prefs.setString('Nickname', nickname);

  setAuth(String auth) => prefs.setString('Auth', auth);

  /// get
  getGrade() => prefs.getInt('Grade') ?? 1;

  getClass() => prefs.getInt('Class') ?? 1;

  getCityCode()=>prefs.getString('CityCode') ?? "J10";

  getSchoolCode() => prefs.getInt('SchoolCode') ?? 7530072;

  getUid() => prefs.getString('ID') ?? '게스트id';

  getNickName() => prefs.getString('Nickname') ?? '게스트';

  getAuth() => prefs.getString('Auth') ?? 'guest';

  UserData getUserData() {
    return UserData(
        uid: getUid(),
        nickname: getNickName(),
        auth: getAuth(),
        Grade: getGrade(),
        Class: getClass(),
        CityCode: getCityCode(),
        SchoolCode: getSchoolCode());
  }

  setUserData(UserData userData) {
    setUid(userData.getUid());
    setNickName(userData.getNickName());
    setAuth(userData.getAuth());
    setGrade(userData.getGrade());
    setClass(userData.getClass());
    setSchoolCode(userData.getSchoolCode());
    print('saveKey: 유저 값 저장');
  }
}


class SaveKeyHandler extends SaveKey{

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
    setAuth('게스트');
    print('saveKey: 게스트가 되었습니다.');
  }
}