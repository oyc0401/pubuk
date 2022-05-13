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

  UserData getUserData() {
    int Grade = prefs.getInt('Grade') ?? 1;
    int Class = prefs.getInt('Class') ?? 1;
    String CityCode = prefs.getString('CityCode') ?? "J10";
    int SchoolCode = prefs.getInt('SchoolCode') ?? 7530072;
    String uid = prefs.getString('ID') ?? '게스트id';
    String nickname = prefs.getString('Nickname') ?? '게스트';
    String auth = prefs.getString('Auth') ?? 'guest';

    return UserData(
        uid: uid,
        nickname: nickname,
        auth: auth,
        Grade: Grade,
        Class: Class,
        CityCode: CityCode,
        SchoolCode: SchoolCode);
  }

  setUser(String uid, String nickname, String auth, int Grade, int Class,
      int SchoolCode) {
    setUid(uid);
    setNickName(nickname);
    setAuth(auth);
    setGrade(Grade);
    setClass(Class);
    setSchoolCode(SchoolCode);
    print('saveKey: 유저 값 저장');
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

  void SwitchGuest() {
    setUid('게스트');
    setNickName('게스트');
    setAuth('게스트');
    print('saveKey: 게스트가 되었습니다.');
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

  setGrade(int Grade) => prefs.setInt('Grade', Grade);

  setClass(int Class) => prefs.setInt('Class', Class);

  setCityCode(String CityCode)=>prefs.setString("CityCode", CityCode);

  setSchoolCode(int SchoolCode) => prefs.setInt('SchoolCode', SchoolCode);

  setUid(String uid) => prefs.setString('ID', uid);

  setNickName(String nickname) => prefs.setString('Nickname', nickname);

  setAuth(String auth) => prefs.setString('Auth', auth);
}
