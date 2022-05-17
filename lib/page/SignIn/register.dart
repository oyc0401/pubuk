import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/SignIn/searchSchool.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:select_dialog/select_dialog.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId:
      '38235317642-4i8ul6m33g6ljpap0bk2b46lv05k1j79.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String univLocalCode = "";
  String univName = "학교를 선택해주세요";
  String univCode = "9421";
  int univLevel = 3;
  int _grade = 1;
  int _class = 1;

  String nickname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //das();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            univButton(),
            SizedBox(
              height: 40,
            ),
            nickNameSection(),
            SizedBox(
              height: 40,
            ),
            gradeButton(),
            SizedBox(
              height: 15,
            ),
            classButton()
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: registerButton(),
    );
  }

  InkWell univButton() {
    return InkWell(
      onTap: NavigateSearch,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xffF5C4C4),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "$univName",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  NavigateSearch() async {
    List list = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SearchSchool(),
      ),
    );
    School school=School.listToSchool(list);

    univLocalCode = school.cityCode;
    univName = school.name;
    univCode = school.schoolCode;
    univLevel = school.level;
    setState(() {

    });
  }

  Widget nickNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "닉네임",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Container(
          height: 30,
          width: 250,
          child: TextFormField(
            onChanged: (text) {
              nickname = text;
            },
            keyboardType: TextInputType.multiline,
            maxLines: 1,

            //decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        const Text(
          "사용 가능한 닉네임 입니다.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  InkWell gradeButton() {
    return InkWell(
      onTap: changeGrade,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "$_grade 학년",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  InkWell classButton() {
    return InkWell(
      onTap: changeClass,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "$_class 반",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  InkWell registerButton() {
    return InkWell(
      onTap: signUp,
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xffFFEC83),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "회원가입",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> changeGrade() async {
    _grade = await getGradeDialog(context, _grade);
    setState(() {});
  }

  Future<void> changeClass() async {
    _class = await getClassDialog(context, _class);
    setState(() {});
  }

  Future<int> getGradeDialog(BuildContext context, int initGrade) async {
    await SelectDialog.showModal<String>(
      context,
      label: "학년을 선택하세요",
      selectedValue: "$initGrade학년",
      items: List.generate(3, (index) {
        var num = index + 1;
        return "$num학년";
      }),
      onChange: (String selected) {
        setState(() {
          var dd = selected.split('');
          initGrade = int.parse(dd[0]);
        });
      },
      showSearchBox: false,
    );

    return initGrade;
  }

  Future<int> getClassDialog(BuildContext context, int initClass) async {
    await SelectDialog.showModal<String>(
      context,
      label: "반을 선택하세요",
      selectedValue: "$initClass반",
      items: List.generate(9, (index) {
        var num = index + 1;
        return "$num반";
      }),
      onChange: (String selected) {
        var dd = selected.split('');
        initClass = int.parse(dd[0]);
      },
      showSearchBox: false,
    );
    return initClass;
  }

  signUp() async {
    print(univName);
    print(univCode);
    print(_grade);
    print(_class);
    print(nickname);
    //print(_class);
  }

  das() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {});

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
      print(user.uid);
    }

    // FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(id)
    //     .get()
    //     .then((value) async {
    //   SaveKey key = await SaveKey.Instance();
    //   key.SetUser(value['ID'], value['nickname'], value['auth'], value['grade'],
    //       value['class']);
    // }).catchError((error) {
    //   print("Failed to Sign in: $error");
    // });
  }
}
