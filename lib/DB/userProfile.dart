class UserProfile {
  String uid ;
  String nickname ;
  int authLevel ;

  // need to make school
  int grade ;
  int Class ;
  String cityCode ;
  String schoolName ;
  String schoolLevel ;
  int schoolCode;

  UserProfile({
    this.uid = '',
    this.nickname = '',
    this.authLevel = 1,
    this.grade = 1,
    this.Class = 1,
    this.cityCode = "J10",
    this.schoolName = "부천북고등학교",
    this.schoolLevel = "고",
    this.schoolCode = 7530072,
  });

  int getGrade() => grade;

  int getClass() => Class;

  int getSchoolCode() => schoolCode;

  String getUid() => uid;

  String getNickName() => nickname;

  int getAuth() => authLevel;

  String getCityCode() => cityCode;

  setGrade(int Grade) => this.grade = Grade;

  setClass(int Class) => this.Class = Class;

  setSchoolCode(int SchoolCode) => this.schoolCode = SchoolCode;

  setUid(String uid) => this.uid = uid;

  setNickName(String nickname) => this.nickname = nickname;

  setAuth(int auth) => this.authLevel = auth;

  factory UserProfile.guestData() {
    return UserProfile(
      uid: 'guest',
      nickname: 'guest',
      authLevel: 1,);
  }

}
