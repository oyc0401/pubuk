import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:provider/provider.dart';


import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import 'UnivModel.dart';
import 'UnivSearch.dart';

class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnivAppBar(),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<UnivInfo>> getUiv() async {
    UnivDB univ = UnivDB();
    List<UnivInfo> li = await univ.getInfo();

    for (UnivInfo element in li) {
      print(element.toMap());
    }
    return li;
  }

  @override
  Widget build(BuildContext context) {
    List<UnivInfo>? favorateUnives =
        Provider.of<UnivModel>(context).favorateUnives;
    if (favorateUnives == null) {
      return Container(
        color: Colors.white,
      );
    } else {
      return succeed(favorateUnives);
    }
  }

  Widget succeed(List<UnivInfo> unives) {
    if (unives.isEmpty) {
      return const Text(
        "북마크한 대학이 없습니다.",
        style: TextStyle(color: Colors.black),
      );
    }
    return ReorderableListView(
      padding: EdgeInsets.symmetric(horizontal: 40),
      children: <Widget>[
        for (int index = 0; index < unives.length; index++)
          UnivCard(
            key: Key('$index'),
            univ: unives[index],
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        Provider.of<UnivModel>(context, listen: false)
            .changePrefer(oldIndex, newIndex);
      },
    );
  }
}

class UnivCard extends StatelessWidget {
  UnivCard({
    Key? key,
    required this.univ,
  }) : super(key: key);
  UnivInfo univ;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              univ.univName,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                //color: Colors.red,
                child: Text("이동하기"),
                onPressed: () {
                  NavigateUnivWeb(context);
                },
              ),
              CupertinoButton(
                child: Text("삭제하기"),
                onPressed: () => Provider.of<UnivModel>(context, listen: false)
                    .delete(univ.univCode),
              ),
            ],
          )
        ],
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
          return UnivSearch(whereClick: WhereClick.main,);
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
