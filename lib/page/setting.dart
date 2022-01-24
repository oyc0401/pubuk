import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int Grade = 1;
  int Class = 1;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future _login() async {
    signInWithGoogle();
  }

  Future _finduser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser?.uid);
    print(auth.currentUser?.email);
    print(auth.currentUser?.phoneNumber);
    print(auth.currentUser?.displayName);
    print(auth.currentUser?.emailVerified);
    print(auth.currentUser?.photoURL);
    print(auth.currentUser?.refreshToken);
    print(auth.currentUser?.tenantId);
  }

  Future<UserCredential> signInWithGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );




    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CupertinoButton(
                onPressed: _login,
                color: Colors.blue,
                child: Text(
                  '구글 로그인',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                )),
            SizedBox(
              height: 50,
            ),
            CupertinoButton(
                onPressed: _finduser,
                color: Colors.blue,
                child: Text(
                  '확인 작업',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                )),
            Row(
              children: [
                Text("학년:"),
                TextButton(
                    onPressed: () {
                      showClassDialog(context);
                    },
                    child: Text("$Grade학년")),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("반:"),
                TextButton(
                    onPressed: () {
                      showGradeDialog(context);
                    },
                    child: Text("$Class반"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Grade = (prefs.getInt('Grade') ?? 1);
      Class = (prefs.getInt('Class') ?? 1);
      print(Grade);
      print(Class);
    });
  }

  _setGrade(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Grade', num);
    });
  }

  _setClass(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Class', num);
    });
  }

  showGradeDialog(BuildContext context) {
    SelectDialog.showModal<String>(
      context,
      label: "반을 선택하세요",
      selectedValue: "$Class반",
      items: List.generate(10, (index) {
        var num = index + 1;
        return "$num반";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          Class = int.parse(dd[0]);
          _setClass(Class);
        });
      },
      showSearchBox: false,
    );
  }

  showClassDialog(BuildContext context) {
    SelectDialog.showModal<String>(
      context,
      label: "학년을 선택하세요",
      selectedValue: "$Grade학년",
      items: List.generate(3, (index) {
        var num = index + 1;
        return "$num학년";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          Grade = int.parse(dd[0]);
          _setGrade(Grade);
        });
      },
      showSearchBox: false,
    );
  }
}
