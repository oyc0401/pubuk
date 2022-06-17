import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterschool/page/MainModel.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:flutterschool/page/Univ/providerWeb.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import '../Profile/profile.dart';
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
    return FutureBuilder(
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
    );
  }

  Widget succeed(List<UnivInfo> unives) {

    if(unives.length==0){
      return Text("북마크한 대학이 없습니다.",style: TextStyle(color: Colors.black),);
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
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          // 배열 설정
          UnivInfo univInfo = unives.removeAt(oldIndex);
          unives.insert(newIndex, univInfo);

          // preference 다시 설정
          UnivDB univ = UnivDB();

          int smallIndex = oldIndex <= newIndex ? oldIndex : newIndex;
          int bigIndex = oldIndex <= newIndex ? newIndex : oldIndex;

          for (int i = smallIndex; i <= bigIndex; i++) {
            unives[i].preference = i;
            univ.updateInfo(unives[i]);
          }
        });
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
}

class UnivCard extends StatelessWidget {
  UnivCard({
    Key? key,
    required this.univ,
  }) : super(key: key);
  UnivInfo univ;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UnivModel>(context);
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
                  NavigateUnivWeb(context, viewModel);
                },
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

  void NavigateUnivWeb(BuildContext context, UnivModel viewModel) {
    Provider.of<UnivModel>(context, listen: false).univCode = univ.univCode;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: viewModel,
            child: UnivProWeb(
              univCode: univ.univCode,
            ),
          );
        },
      ),
    );
  }

  void deleteUniv() async {
    UnivDB univdb = UnivDB();
    await univdb.deleteInfo(univ.id);
  }
}

class UnivAppBar extends StatelessWidget with PreferredSizeWidget {
  UnivAppBar({Key? key}) : super(key: key);

  final double height = 80;
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    void NavigateUnivSearch() async {
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return UnivSearch();
          },
        ),
      );
    }

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
            onPressed: NavigateUnivSearch,
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

  @override
  Size get preferredSize => Size.fromHeight(height);
}
