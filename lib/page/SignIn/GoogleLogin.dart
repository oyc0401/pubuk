import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../DB/userProfile.dart';
import 'Login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class GoogleLogin implements Login {
  @override
  String? uid;

  @override
  Future<void> login() async {
    UserCredential? userCredential = await signInWithGoogle();
    uid = userCredential?.user?.uid;
  }

  Future<UserCredential?> signInWithGoogle() async {
    print("구글 로그인 하는중...");
    // 로그인 창 열기
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("구글 로그인 성공!");
      return userCredential;
    } else {
      print("로그인 취소");
      return null;
    }
  }

  @override
  deleteUser() async {
    await reAuth();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        print("firebase Auth 계정 삭제 완료.");
      } else {
        print("현재 유저가 없습니다.");
      }
    } on FirebaseAuthException catch (e) {
      print("회원탈퇴 실패");
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      } else {
        print(e.code);
      }
    }
    _googleSignIn.disconnect();
    print("google 소셜 로그인 연결끊기.");
  }

  @override
  logout() async {
    FirebaseAuth.instance.signOut();
    _googleSignIn.signOut();
    print("로그아웃");
  }

  @override
  Future<void> reAuth() async {
    print("구글 재인증하는중...");
    // 조용히 로그인 하기
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signInSilently();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("구글 재인증 성공!");
    } else {
      print("재 인증 실패, 다시 로그인해야합니다.");
      await signInWithGoogle();
    }
  }
}
