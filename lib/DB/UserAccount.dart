class UserAccount{
  // user
  String uid; // 유저 id
  String nickname; // 닉네임
  int authLevel; // 자신의 권한 1 = user, 2= teacher, 3 = parents, 10 = master
  String provider; // 로그인 환경
  String authId; // firebase authId: 카카오 로그인시 id가 뭔지 확인하기 위해서
  String certifiedSchoolCode; // 인증 받은 학교 코드
  UserAccount(
      {this.uid = 'guest',
        this.nickname = '',
        this.authLevel = 1,
        this.provider = "",
        this.authId = "",
        this.certifiedSchoolCode = "null"});

}