import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class RoundButton extends StatelessWidget {
  /// 좌우가 동그란 버튼
  String text;
  double width;
  double height;
  double fontSize;
  GestureTapCallback onclick;
  Color color;

  RoundButton({
    required this.onclick,
    required this.text,
    this.width = 300,
    this.height = 50,
    this.color = Colors.grey,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  String text;
  double height;
  double fontSize;
  GestureTapCallback onclick;
  Color color;

  LoginButton({
    required this.onclick,
    required this.text,
    this.height = 44,
    this.color = Colors.grey,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

