import 'package:shared_preferences/shared_preferences.dart';

class saveKey {
  late SharedPreferences prefs;



init()async{
  prefs = await SharedPreferences.getInstance();

}


  nickname(){
    return prefs.getString('Nickname')??'게스트';
  }


  SwitchGuest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ID', '게스트');
    prefs.setString('Nickname', '게스트');
    prefs.setString('Auth', 'guest');
  }

  ChangeGrade(int Grade, int Class) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('Grade', Grade);
    prefs.setInt('Class', Class);
  }

  Changeinfo(String nickname,int Grade, int Class) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Nickname', nickname);
    prefs.setInt('Grade', Grade);
    prefs.setInt('Class', Class);
    print('정보 변경');
  }

}
