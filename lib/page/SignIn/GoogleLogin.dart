import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class GoogleLogin {
  String? uid;

  Future<void> login() async {
    UserCredential? userCredential = await signInWithGoogle();
    uid = userCredential?.user?.uid;
  }

  Future<UserCredential?> signInWithGoogle() async {
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

      return userCredential;
    } else {
      print("로그인 취소");
      return null;
    }
  }
}
