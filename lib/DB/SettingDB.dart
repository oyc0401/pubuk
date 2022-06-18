import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  double webScale;

  Setting({this.webScale = 1.5});

  static Setting? _current;

  static initializeSetting() async {
    KeyValue savePro = await KeyValue.Instance();
    _current = savePro.getSetting();
  }

  static Setting get currentSetting {
    assert(_current != null, "Warning: 설정 초기화가 필요합니다.");
    return _current!;
  }

  static Future<void> save(Setting setting) async {
    _current = setting;
    print("static setting update");
    KeyValue keyValue = await KeyValue.Instance();
    keyValue.setSetting(setting);
  }
}

class KeyValue {
  // set 하는것은 Instance가 필요 없지만
  // get 은 퓨처값을 주지 말아야 하기 때문에 Instance가 필요하다.
  late SharedPreferences prefs;

  static Instance() async {
    KeyValue key = KeyValue();
    key.prefs = await SharedPreferences.getInstance();
    return key;
  }

  void setSetting(Setting setting) {
    _setWebScale(setting.webScale);
  }

  Setting getSetting() {
    return Setting(
      webScale: _getWebScale(),
    );
  }

  Setting setting = Setting();

  /// set
  void _setWebScale(double webScale) => prefs.setDouble('webScale', webScale);


  /// get
  double _getWebScale() => prefs.getDouble('webScale') ?? setting.webScale;
}
