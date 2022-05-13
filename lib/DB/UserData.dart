
class UserData {
  String _uid = "";
  String _nickname = "";
  String _auth = "";
  int _Grade = 1;
  int _Class = 1;
  String _CityCode="J10";
  String _schoolName="고등학교";
  String _schoolLevel="고";
  int _SchoolCode = 13;

  UserData({
    required String uid,
    required String nickname,
    required String auth,
    required int Grade,
    required int Class,
    required String CityCode,
    required int SchoolCode,
  }) {
    _uid = uid;
    _nickname = nickname;
    _auth = auth;
    _Grade = Grade;
    _Class = Class;
    _CityCode=CityCode;
    _SchoolCode = SchoolCode;
  }



  int getGrade() => _Grade;

  int getClass() => _Class;

  int getSchoolCode() => _SchoolCode;

  String getUid() => _uid;

  String getNickName() => _nickname;

  String getAuth() => _auth;

  String getCityCode()=>_CityCode;

  setGrade(int Grade) => _Grade=Grade;
  setClass(int Class) => _Class=Class;
  setSchoolCode(int SchoolCode) => _SchoolCode=SchoolCode;
  setUid(String uid) => _uid=uid;
  setNickName(String nickname) => _nickname=nickname;
  setAuth(String auth) => _auth=auth;

  factory UserData.guestData() {
    return UserData(
        uid: 'guest',
        nickname: 'guest',
        auth: 'guest',
        Grade: 1,
        Class: 1,
        CityCode: "J10",
        SchoolCode: 7530072);
  }
  factory UserData.noData() {
    return UserData(
        uid: '',
        nickname: '',
        auth: '',
        Grade: 1,
        Class: 1,
        CityCode: "J10",
        SchoolCode: 7530072);
  }
}
