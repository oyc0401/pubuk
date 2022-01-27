import 'package:flutterschool/DB/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveKey {
  // set 하는것은 getInstance가 필요 없지만
  // get 은 퓨처값을 주지 말아야 하기 때문에 getInstance가 필요하다.
  late SharedPreferences prefs;

  getInstance() async {
    SaveKey key = SaveKey();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  UserData userData() {
    int Grade = prefs.getInt('Grade') ?? 1;
    int Class = prefs.getInt('Class') ?? 1;
    String uid = prefs.getString('ID') ?? '게스트id';
    String nickname = prefs.getString('Nickname') ?? '게스트';
    String auth = prefs.getString('Auth') ?? 'guest';

    return UserData(
        uid: uid, nickname: nickname, auth: auth, Grade: Grade, Class: Class);
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
