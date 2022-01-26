class Userboxorigin {
  final int id;
  final String uid;
  final String nickname;
  final String auth;
  final String email;
  final String displayName;
  final String signupDate;
  final String photoURL;
  final int Grade;
  final int Class;

  Userboxorigin({
    required this.id,
    required this.uid,
    required this.nickname,
    required this.auth,
    required this.email,
    required this.displayName,
    required this.signupDate,
    required this.photoURL,
    required this.Grade,
    required this.Class,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'nickname': nickname,
      'auth': auth,
      'email': email,
      'displayName': displayName,
      'signupDate': signupDate,
      'photoURL': photoURL,
      'Grade': Grade,
      'Class': Class
    };
  }

  // 각 User 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'User{id: $id, uid: $uid, nickname: $nickname}';
  }
}
