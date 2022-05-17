import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  String univName = "부천북고등학교";
  String univCode = "99444";
  int _grade = 1;
  int _class = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //das();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            univButton(),
            nickNameSection(),
            gradeButton(),
            classButton()
          ],
        ),
      ),
    );
  }

  InkWell univButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xffF5C4C4),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "부천북고등학교",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget nickNameSection() {
    return Column(
      children: [
        Text(
          "닉네임",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        TextFormField(
          onChanged: (text){  },
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          //decoration: const InputDecoration(border: InputBorder.none),
        ),
      ],
    );
  }

  InkWell gradeButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
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
      child: Container(
        width: 300,
        height: 50,
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
