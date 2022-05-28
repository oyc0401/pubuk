import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/page/Home/home.dart';
import 'package:flutterschool/page/SignIn/searchSchool.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:select_dialog/select_dialog.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String schoolLocalCode = "J10";
  String schoolName = "부천북고";
  int schoolCode = 7530072;
  int schoolLevel = 3;
  int _grade = 1;
  int _class = 1;
  String nickname = "";

  User? user;
  UserProfile userProfile = UserProfile();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  signUp() async {
    print(schoolName);
    print(schoolCode);
    print(_grade);
    print(_class);
    print(nickname);
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print(user!.uid);
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .set({
            'uid': user!.uid,
            'authLevel': 1,
            'class': 1,
            'grade': 1,
            'nickname': nickname,
            'schoolLocalCode': schoolLocalCode,
            'schoolName': schoolName,
            'schoolCode': schoolCode,
            'schoolLevel': schoolLevel,
            'certifiedSchoolCode': 'null',
          })
          .then((value) async {})
          .catchError((error) {
            print("Failed to Sign in: $error");
          });
    }


    userProfile.uid = user!.uid;
    userProfile.nickname = nickname;
    userProfile.grade = _grade;
    userProfile.Class = _class;
    userProfile.schoolName = schoolName;
    userProfile.schoolLocalCode = schoolLocalCode;
    userProfile.schoolLevel = schoolLevel;

    await UserProfile.Save(userProfile);

    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(title: "학교"),
        ),
        (route) => false);
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
            "$schoolName",
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
    School school = School.listToSchool(list);

    schoolLocalCode = school.cityCode;
    schoolName = school.name;
    schoolCode = int.parse(school.schoolCode);
    schoolLevel = school.level;
    setState(() {});
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

// addUser(){
//   FirebaseFirestore.instance.collection('users').doc(date).set({
//     'ID': date,
//     'userid': id,
//     'nickname': nickname,
//     'text': text,
//     'title': title,
//     'heart': 0,
//     'commment': 0,
//     'auth': auth,
//     'image': image,
//     'date': date,
//   }).then((value) {
//     print("User Added");
//   }).catchError((error) => print("Failed to add user: $error"));
// }
}
