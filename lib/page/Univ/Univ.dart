import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:skeletons/skeletons.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import '../Profile/profile.dart';

class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  UserProfile userProfile = UserProfile.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: FutureBuilder(
          future: getUiv(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return waiting();
            } else if (snapshot.hasError) {
              return error(snapshot);
            } else {
              List<UnivInfo> unives = snapshot.data;
              return succeed(unives);
            }
          },
        ));
  }

  Widget succeed(List<UnivInfo> unives) {
    return ListView.builder(
      itemCount: unives.length,
      itemBuilder: (context, index) {
        return UnivCard(
          univInfo: unives[index],
        );
      },
    );
  }

  Widget error(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Error: ${snapshot.error}',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget waiting() {
    return Skeleton(
      isLoading: true,
      skeleton: const SkeletonAvatar(
          style: SkeletonAvatarStyle(width: 480, height: 450)),
      child: Container(),
    );
  }

  Future<List<UnivInfo>> getUiv() async {
    UnivDB univ = UnivDB();
    List<UnivInfo> li = await univ.getInfo();

    for (UnivInfo element in li) {
      print(element.toMap());
    }
    return li;
  }

  AppBar buildAppBar() {
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
            onPressed: NavigateUnivWeb,
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
  void NavigateUnivWeb() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>  UnivWeb(
          year: 2023,
          univCode: "0000169",
        ),
      ),
    );
  }
}

class UnivCard extends StatefulWidget {
  UnivCard({
    Key? key,
    required this.univInfo,
  }) : super(key: key);
  UnivInfo univInfo;

  @override
  State<UnivCard> createState() => _UnivCardState();
}

class _UnivCardState extends State<UnivCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.univInfo.univName,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                //color: Colors.red,
                child: Text("이동하기"),
                onPressed: NavigateUnivWeb,
              ),
              CupertinoButton(
                child: Text("삭제하기"),
                onPressed: deleteUniv,
              ),
            ],
          )
        ],
      ),
    );
  }

  deleteUniv() async {
    UnivDB univ = UnivDB();
    univ.deleteInfo(widget.univInfo.id);
  }

  void NavigateUnivWeb() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UnivWeb(
          year: 2023,
          univCode: widget.univInfo.univCode,
        ),
      ),
    );
  }
// setState((){});
}
