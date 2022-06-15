import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/UnivDB.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';

import 'UnivWeb.dart';

class UnivSearch extends StatefulWidget {
  const UnivSearch({Key? key}) : super(key: key);

  @override
  State<UnivSearch> createState() => _UnivSearchState();
}

class _UnivSearchState extends State<UnivSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            print(UnivName.UnivList().length);
            // return UnivName.UnivList()[i]
            return UnivSelection(univInfo: UnivInfo(id: "0000004",univCode: "0000004", univName: "강원대학교"),);
          },
        ),
      ),
    );
  }
}

class UnivSelection extends StatefulWidget {
  UnivSelection({Key? key, required this.univInfo}) : super(key: key);
  UnivInfo univInfo;

  @override
  State<UnivSelection> createState() => _UnivSelectionState();
}

class _UnivSelectionState extends State<UnivSelection> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        NavigateUnivWeb();
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(child: Text(widget.univInfo.univName)),
      ),
    );
  }

  pop(){
    Navigator.of(context).pop('complete');
  }

  void NavigateUnivWeb() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UnivWeb(
          year: 2023,
          univCode: widget.univInfo.univCode,
        ),
      ),
    );
  }
}
