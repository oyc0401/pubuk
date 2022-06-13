import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'Login.dart';

class KakaoLogin implements Login {
  @override
  String? uid;

  @override
  Future<bool> login() async {
    // kakao, firebase 로그인이 성공 하면
    if (await signInWithKaKao() && await anonymousLogin()) {
      uid = await getUid();
      return true;
    }
    return false;
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

  @override
  Future<bool> logout() async {
    await fire.FirebaseAuth.instance.signOut();
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
      return true;
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
    return false;
  }
  getCurrentUser()async{
    User user=await UserApi.instance.me();
    return user.toString();
  }

  @override
  Future<bool> deleteUser() async {

    bool isok = await reAuth();
    if (isok) {
      // 파이어베이스 재 로그인
      fire.FirebaseAuth.instance.signInAnonymously();
      try {
        // 카카오 연결 끊기
        await UserApi.instance.unlink();
        print('연결 끊기 성공, SDK에서 토큰 삭제');
        // 파이어베이스 연결 끊기
        await fire.FirebaseAuth.instance.currentUser?.delete();
        return true;
      } catch (error) {
        print('연결 끊기 실패 $error');
        return false;
      }

    }
    print("재 로그인 안됌");
    return false;
  }



  @override
  Future<bool> reAuth() async {


    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 정보 보기 성공'
            '\n회원정보: ${tokenInfo.id}'
            '\n만료시간: ${tokenInfo.expiresIn} 초');
        return true;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음');
    }
    if (await login()) {
      return true;
    } else {
      return false;
    }
  }

  _checkToken() async {}
}
