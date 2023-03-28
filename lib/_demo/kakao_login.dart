import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

Future<void> main() async {
  kakao.KakaoSdk.init(nativeAppKey: '3e345bcd63a5df82971a7d52cabb73a2');

  runApp(const KakaoLoginTestPage());
}

class KakaoLoginTestPage extends StatefulWidget {
  const KakaoLoginTestPage({Key? key}) : super(key: key);

  @override
  State<KakaoLoginTestPage> createState() => _KakaoLoginTestPageState();
}

class _KakaoLoginTestPageState extends State<KakaoLoginTestPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            CupertinoButton(
                child: Text("로그인"),
                onPressed: () {
                  KakaoLogin ka = KakaoLogin();
                  ka.signInWithKaKao();
                })
          ],
        ),
      ),
    );
  }
}

class KakaoLogin {
  Future<bool> signInWithKaKao() async {
    // 카카오톡 앱이 있을경우
    if (await isKakaoTalkInstalled()) {
      // 카카오톡 앱으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공: $token');
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
}
