// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterschool/main.dart';
import 'package:ntp/ntp.dart';

void main() {

  //시간 테스트 할때 썼던 함수
  Future<void> TimeTest() async {
    //시간 테스트 할때 썼던 함수

    //파베에 글쓰기만 함

    //몇분전 이런거 테스트하는 함수
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";

    //6년전
    date = '2016-01-15 05:01:52.056883'; //지워라!!!
    FirebaseFirestore.instance.collection('pubuk').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': 'text',
      'title': 'text',
      'image': "abc,bcd,fds,rew",
      'date': date,
    }).then((value) {
      print("User Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));

    //6달전
    date = '2021-07-15 05:01:52.056883'; //지워라!!!
    FirebaseFirestore.instance.collection('pubuk').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': 'text',
      'title': 'text',
      'image': "abc,bcd,fds,rew",
      'date': date,
    }).then((value) {
      print("User Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));

    //14일전
    date = '2022-01-01 05:01:52.056883'; //지워라!!!
    FirebaseFirestore.instance.collection('pubuk').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': "text",
      'title': "text",
      'image': "abc,bcd,fds,rew",
      'date': date,
    }).then((value) {
      print("User Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));

    //10시간전
    date = '2022-01-15 11:01:52.056883'; //지워라!!!
    FirebaseFirestore.instance.collection('pubuk').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': "text",
      'title': "text",
      'image': "abc,bcd,fds,rew",
      'date': date,
    }).then((value) {
      print("User Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));

    //20분전
    date = '2022-01-15 21:01:37.725114'; //지워라!!!
    FirebaseFirestore.instance.collection('pubuk').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': "text",
      'title': "text",
      'image': "abc,bcd,fds,rew",
      'date': date,
    }).then((value) {
      print("User Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));


  }
}
