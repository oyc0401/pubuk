import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/UnivDB.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:provider/provider.dart';

import 'UnivModel.dart';

enum WhereClick { main, web }

class UnivSearch extends StatelessWidget {
  List codes = UnivName.univCodeList;
  List names = UnivName.univNameList;

  UnivSearch({Key? key, required this.whereClick}) : super(key: key);
  WhereClick whereClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
          itemCount: codes.length,
          itemBuilder: (context, index) {
            //print(UnivName.getUnivName(list[index]));
            return UnivSelection(
              univInfo: UnivInfo(
                id: codes[index],
                univCode: codes[index],
                univName: names[index],
                preference: UnivDB.lenght,
              ),
              whereClick: whereClick,
            );
          },
        ),
      ),
    );
  }
}

class UnivSelection extends StatelessWidget {
  UnivSelection({Key? key, required this.univInfo, required this.whereClick})
      : super(key: key);
  UnivInfo univInfo;
  WhereClick whereClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigateUnivWeb(context),
      child: Container(
        height: 60,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(child: Text(univInfo.univName)),
      ),
    );
  }

  void NavigateUnivWeb(BuildContext context) async {
    Provider.of<UnivModel>(context, listen: false)
        .changeUnivCode(univInfo.univCode);

    switch (whereClick) {
      case WhereClick.main:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UnivWeb(),
          ),
        );
        break;
      case WhereClick.web:
        Navigator.of(context).pop(true);
        break;
    }
  }
}
