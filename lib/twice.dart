import 'package:flutter/material.dart';

class twice extends StatefulWidget {
  const twice({Key? key}) : super(key: key);

  @override
  State<twice> createState() => _twiceState();
}

class _twiceState extends State<twice> {
  @override
  Widget build(BuildContext context) {
    print("setState");
    return Scaffold(
      appBar: AppBar(
        title: Text("두번"),
      ),
      body: Container(),
    );
  }
}
