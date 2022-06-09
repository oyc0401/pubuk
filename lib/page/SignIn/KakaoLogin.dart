import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin {
  String? uid;

  login() async {
    // kakao, firebase 로그인이 성공 하면
    if (await signInWithKaKao() && await anonymousLogin()) {
      uid = await getUid();
    }
  }

  Future<String?> getUid() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');

      return "${user.id}";
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
    return null;
  }

  Future<bool> anonymousLogin() async {
    print("익명 로그인");
    try {
      final userCredential =
          await fire.FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      return true;
    } on fire.FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return false;
  }

  Future<bool> signInWithKaKao() async {
    // 카카오톡 앱이 있을경우
    if (await isKakaoTalkInstalled()) {
      // 카카오톡 앱으로 로그인
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        return true;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          return true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        return true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
  }

  logout() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  deleteUser() async {
    try {
      await UserApi.instance.unlink();
      print('연결 끊기 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('연결 끊기 실패 $error');
    }
  }
}
