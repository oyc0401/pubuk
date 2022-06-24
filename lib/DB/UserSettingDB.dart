import 'package:shared_preferences/shared_preferences.dart';

class UserSetting {
  double longitude;
  double latitude;

  UserSetting({
    this.longitude = 126.7891462,
    this.latitude = 37.5185948,
  });


  static UserSetting? _current;

  static initializeUserSetting() async {
    LocateKeyValue savePro = await LocateKeyValue.Instance();
    _current = savePro.getSetting();
  }

  static UserSetting get current {
    assert(_current != null, "Warning: 설정 초기화가 필요합니다.");
    return _current!;
  }

  static Future<void> save(UserSetting setting) async {
    _current = setting;
    print("static setting update");
    LocateKeyValue keyValue = await LocateKeyValue.Instance();
    keyValue.setSetting(setting);
  }
}

class LocateKeyValue {
  // set 하는것은 Instance가 필요 없지만
  // get 은 퓨처값을 주지 말아야 하기 때문에 Instance가 필요하다.
  late SharedPreferences prefs;
  UserSetting setting = UserSetting();

  static Instance() async {
    LocateKeyValue key = LocateKeyValue();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  void setSetting(UserSetting setting) {
    prefs.setDouble('longitude', setting.longitude);
    prefs.setDouble('latitude', setting.latitude);
  }

  UserSetting getSetting() {
    return UserSetting(
        longitude: prefs.getDouble('longitude') ?? setting.longitude,
        latitude: prefs.getDouble('latitude') ?? setting.latitude,
    );
  }

}
