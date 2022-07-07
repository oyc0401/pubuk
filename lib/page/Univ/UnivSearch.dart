import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/UnivDB.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:flutterschool/page/Univ/UnivSearchModel.dart';
import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:provider/provider.dart';

import 'UnivModel.dart';

enum WhereClick { main, web }

class UnivSearch extends StatelessWidget {
  UnivSearch({Key? key, required this.whereClick}) : super(key: key);
  WhereClick whereClick;

  @override
  Widget build(BuildContext context) {
    List univDatas = Provider.of<UnivSearchModel>(context).unives;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              CupertinoButton(
                  child: Text("이름순 정렬"),
                  onPressed: () {
                    Provider.of<UnivSearchModel>(context, listen: false)
                        .sortUnives(Sort.name);
                  }),
              CupertinoButton(
                  child: Text("거리순 정렬"),
                  onPressed: () {
                    Provider.of<UnivSearchModel>(context, listen: false)
                        .sortUnives(Sort.distance);
                  }),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: univDatas.length,
              itemBuilder: (context, index) {
                return UnivSelection(
                    univData: univDatas[index], whereClick: whereClick);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UnivSelection extends StatelessWidget {
  UnivSelection(
      {Key? key, required this.univData, this.whereClick = WhereClick.main})
      : super(key: key);
  UnivData univData;
  WhereClick whereClick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(univData.name),
      subtitle: Text("${univData.getKm()}km, ${univData.getAddress()}"),
      onTap: () => NavigateUnivWeb(context),
    );
  }

  void NavigateUnivWeb(BuildContext context) async {
    Provider.of<UnivModel>(context, listen: false)
        .changeUnivCode(univData.code);

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
