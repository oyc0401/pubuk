class UserProfile {
  String uid;

  String nickname;

  int authLevel;

  // need to make school
  int grade;

  int Class;

  String schoolLocalCode;

  String schoolName;

  int schoolLevel;

  int schoolCode;
  String certifiedSchoolCode;

  UserProfile(
      {this.uid = '',
      this.nickname = '',
      this.authLevel = 1,
      this.grade = 1,
      this.Class = 1,
      this.schoolLocalCode = "J10",
      this.schoolName = "부천북고등학교",
      this.schoolLevel = 3,
      this.schoolCode = 7530072,
      this.certifiedSchoolCode = "null"});

  int getGrade() => grade;

  int getClass() => Class;

  int getSchoolCode() => schoolCode;

  String getUid() => uid;

  String getNickName() => nickname;

  int getAuth() => authLevel;

  String getCityCode() => schoolLocalCode;

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
      authLevel: 1,
    );
  }

  factory UserProfile.FirebaseUser(Map map) {
    return UserProfile(
      uid: map['uid'],
      authLevel: map['authLevel'],
      Class: map['class'],
      grade: map['grade'],
      nickname: map['nickname'],
      schoolLocalCode: map['schoolLocalCode'],
      schoolName: map['schoolName'],
      schoolCode: map['schoolCode'],
      schoolLevel: map['schoolLevel'],
      certifiedSchoolCode: map['certifiedSchoolCode'],
    );
  }
}
