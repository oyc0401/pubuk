import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/UnivPreference.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:provider/provider.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import 'UnivDownLoad.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';


class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    // UnivDownloader univDownloader =
    //     UnivDownloader(univName: "인하", univType: UnivType.main);
    // await univDownloader.downLoad();
    // UnivData univData = univDownloader.getData();
    // print(univDownloader.Json);
    // print(univData);
  }

  @override
  Widget build(BuildContext context) {
    List<UnivInfo>? favorateUnives =
        Provider.of<UnivModel>(context).favorateUnives;
    if (favorateUnives == null) {
      return Container(
        color: Colors.white,
      );
    }

    return Scaffold(
      appBar: UnivAppBar(),
      body: Column(
        children: [
          CupertinoButton(
            child: Text("위치 수정"),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => UnivPreference()),
              );
            },
          ),
          for (UnivInfo univ in favorateUnives) UnivBar(univ: univ)
        ],
      ),
    );
  }
}

class UnivBar extends StatelessWidget {
  UnivBar({
    Key? key,
    required this.univ,
  }) : super(key: key);
  UnivInfo univ;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          backgroundImage: NetworkImage(
              "https://upload.wikimedia.org/wikipedia/commons/6/67/InhaUniversity_Emblem.jpg"),
        ),
        title: Text(
          univ.univName,
          style: TextStyle(fontSize: 24),
        ),
        trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showSelectDialog(context)),
        onTap: () => NavigateUnivWeb(context),
        subtitle: Text("24km"),
        //onLongPress: ()=> showSelectDialog(context),
      ),
    );
  }

  void showSelectDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              onPressed: () {
                Provider.of<UnivModel>(context, listen: false)
                    .delete(univ.univCode);
                Navigator.of(context).pop();
              },
              child: Text(
                "삭제",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => UnivPreference()),
                );
              },
              child: Text(
                "순서 변경",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
        titlePadding: EdgeInsets.all(8.0),
      ),
    );
  }

  void NavigateUnivWeb(BuildContext context) {
    /// webview code 변경, 시작 할 땐 2023년 으로
    Provider.of<UnivModel>(context, listen: false).univCode = univ.univCode;
    Provider.of<UnivModel>(context, listen: false).year = 2023;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: Provider.of<UnivModel>(context),
            child: UnivWeb(),
          );
        },
      ),
    );
  }
}

class UnivAppBar extends StatelessWidget with PreferredSizeWidget {
  UnivAppBar({Key? key}) : super(key: key);

  final double height = 80;
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProfile.schoolName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.normal),
          ),
          Text(
            '${userProfile.grade}학년 ${userProfile.Class}반',
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      //backgroundColor: Colors.blue,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 24, right: 8),
          child: IconButton(
            onPressed: () {
              NavigateUnivSearch(context);
            },
            icon: const Icon(
              Icons.search,
              size: 28,
              color: Color(0xff191919),
            ),
          ),
        ),
      ],
    );
  }

  void NavigateUnivSearch(BuildContext context) async {
    Provider.of<UnivModel>(context, listen: false).year = 2023;
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return UnivSearch(
            whereClick: WhereClick.main,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}





