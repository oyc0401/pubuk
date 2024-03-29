// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterschool/DB/userProfile.dart';
// import 'package:flutterschool/Server/FirebaseAirPort.dart';
// import 'package:flutterschool/page/Home/home.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:select_dialog/select_dialog.dart';
//
// import '../../MyWidget/button.dart';
// import '../../Server/FireTool.dart';
// import '../Home/HomeModel.dart';
// import '../mainPage.dart';
//
// class Register extends StatefulWidget {
//   Register({Key? key, required String uid, required String provider})
//       : userProfile = UserProfile(uid: uid, provider: provider),
//         super(key: key);
//
//   UserProfile userProfile;
//
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//
//   @override
//   initState(){
//     super.initState();
//     widget.userProfile.authId=FirebaseAuth.instance.currentUser?.uid??"";
//   }
//
//   Future<void> signUp() async {
//
//     /// 파이어베이스 DB 에 저장
//     FirebaseAirPort airPort=FirebaseAirPort(uid: widget.userProfile.uid);
//     await airPort.set(widget.userProfile);
//
//     /// 로컬 DB에 저장
//     await UserProfile.save(widget.userProfile);
//
//     Provider.of<HomeModel>(context, listen: false).setClass();
//
//     navigateHome();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 120,
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             nickNameSection(),
//             SizedBox(
//               height: 40,
//             ),
//             gradeButton(),
//             SizedBox(
//               height: 15,
//             ),
//             classButton()
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: RoundTextButton(
//         onclick: signUp,
//         text: '회원가입',
//         color: Color(0xffFFEC83),
//         fontSize: 20,
//       ),
//     );
//   }
//
//   Widget nickNameSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "닉네임",
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//         Container(
//           height: 30,
//           width: 250,
//           child: TextFormField(
//             onChanged: (text) {
//               widget.userProfile.nickname = text;
//             },
//             keyboardType: TextInputType.multiline,
//             maxLines: 1,
//
//             //decoration: const InputDecoration(border: InputBorder.none),
//           ),
//         ),
//         SizedBox(
//           height: 8,
//         ),
//         const Text(
//           "사용 가능한 닉네임 입니다.",
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.blue,
//           ),
//         ),
//       ],
//     );
//   }
//
//   InkWell gradeButton() {
//     return InkWell(
//       onTap: changeGrade,
//       child: Container(
//         width: 300,
//         height: 45,
//         decoration: BoxDecoration(
//           color: Color(0xffF6F6F6),
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: Text(
//             "${widget.userProfile.grade} 학년",
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InkWell classButton() {
//     return InkWell(
//       onTap: changeClass,
//       child: Container(
//         width: 300,
//         height: 45,
//         decoration: BoxDecoration(
//           color: Color(0xffF6F6F6),
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: Text(
//             "${widget.userProfile.Class} 반",
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> changeGrade() async {
//     widget.userProfile.grade =
//         await getGradeDialog(context, widget.userProfile.grade);
//     setState(() {});
//   }
//
//   Future<void> changeClass() async {
//     widget.userProfile.Class =
//         await getClassDialog(context, widget.userProfile.Class);
//     setState(() {});
//   }
//
//   Future<int> getGradeDialog(BuildContext context, int initGrade) async {
//     await SelectDialog.showModal<String>(
//       context,
//       label: "학년을 선택하세요",
//       selectedValue: "$initGrade학년",
//       items: List.generate(3, (index) {
//         var num = index + 1;
//         return "$num학년";
//       }),
//       onChange: (String selected) {
//         setState(() {
//           var dd = selected.split('');
//           initGrade = int.parse(dd[0]);
//         });
//       },
//       showSearchBox: false,
//     );
//
//     return initGrade;
//   }
//
//   Future<int> getClassDialog(BuildContext context, int initClass) async {
//     await SelectDialog.showModal<String>(
//       context,
//       label: "반을 선택하세요",
//       selectedValue: "$initClass반",
//       items: List.generate(9, (index) {
//         var num = index + 1;
//         return "$num반";
//       }),
//       onChange: (String selected) {
//         var dd = selected.split('');
//         initClass = int.parse(dd[0]);
//       },
//       showSearchBox: false,
//     );
//     return initClass;
//   }
//
//   navigateHome() {
//     Navigator.pushAndRemoveUntil(
//         context,
//         CupertinoPageRoute(
//           builder: (context) => const MyHomePage(),
//         ),
//         (route) => false);
//   }
// }
