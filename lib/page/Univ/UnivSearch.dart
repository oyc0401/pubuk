import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/UnivDB.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:provider/provider.dart';

import 'UnivModel.dart';
import 'beforeWeb.dart';

enum WhereClick{
  main,
    web
}

WhereClick where=WhereClick.main;
class UnivSearch extends StatefulWidget {
   UnivSearch({Key? key,required this.whereClick}) : super(key: key);

  WhereClick whereClick;
  @override
  State<UnivSearch> createState() => _UnivSearchState();
}

class _UnivSearchState extends State<UnivSearch> {
  List codes = UnivName.univCodeList;
  List names = UnivName.univNameList;

  @override
  Widget build(BuildContext context) {
    where=widget.whereClick;
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
            ));
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
      onTap: () {
        NavigateUnivWeb();
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(child: Text(widget.univInfo.univName)),
      ),
    );
  }

  void NavigateUnivWeb() async {
    Provider.of<UnivModel>(context, listen: false)
        .changeUnivCode(widget.univInfo.univCode);


    switch(where){
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
