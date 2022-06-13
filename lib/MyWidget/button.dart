import 'package:flutter/material.dart';

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
    this.fontSize=18,
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



