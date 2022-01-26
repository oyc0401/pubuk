class Userinfo {
  final String uid;
  final String nickname;
  final String auth;
  final int Grade;
  final int Class;

  Userinfo({
    required this.uid,
    required this.nickname,
    required this.auth,
    required this.Grade,
    required this.Class,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'auth': auth,
      'Grade': Grade,
      'Class': Class
    };
  }

  // 각 User 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
 
  @override
  String toString() {
    return 'User{uid: $uid, nickname: $nickname}';
  }
}
