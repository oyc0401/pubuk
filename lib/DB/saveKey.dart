import 'package:shared_preferences/shared_preferences.dart';

class SaveKey {
  late SharedPreferences prefs;

  getInstance() async {
    SaveKey key = SaveKey();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  int Grade() {
    return prefs.getInt('Grade') ?? 1;
  }

  int Class() {
    return prefs.getInt('Class') ?? 1;
  }

  String uid() {
    return prefs.getString('ID') ?? '게스트id';
  }

  String nickname() {
    return prefs.getString('Nickname') ?? '게스트';
  }


  SwitchGuest() {
    prefs.setString('ID', '게스트');
    prefs.setString('Nickname', '게스트');
    prefs.setString('Auth', 'guest');
    print('saveKey: 게스트가 되었습니다.');
  }

  Changeinfo(String nickname, int Grade, int Class) {
    prefs.setString('Nickname', nickname);
    prefs.setInt('Grade', Grade);
    prefs.setInt('Class', Class);
    print('saveKey: 정보 변경');
  }

  SetUser(String uid, String nickname, String auth, int Grade, int Class) {
    prefs.setString('ID', uid);
    prefs.setString('Nickname', nickname);
    prefs.setString('Auth', auth);
    prefs.setInt('Grade', Grade);
    prefs.setInt('Class', Class);
    print('saveKey: 유저 값 저장');
  }

  printAll() {
    print(prefs.getKeys());
    print(prefs.get('ID'));
    print(prefs.get('Grade'));
    print(prefs.get('Class'));
    print(prefs.get('Nickname'));
    print(prefs.get('Auth'));
  }
}
