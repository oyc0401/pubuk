import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  UserProfile userProfile = UserProfile.currentUser;

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


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UnivModel(
          univCode: "0000046",
          year: 2023,
          univWay: UnivWay.comprehensive,
          isLike: false),
      child: Scaffold(
          appBar: buildAppBar(),
          body: Body()),
    );
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


class UnivCard extends StatefulWidget {
  UnivCard({
    Key? key,
    required this.univ,
  }) : super(key: key);
  UnivInfo univ;

  @override
  State<UnivCard> createState() => _UnivCardState();
}

class _UnivCardState extends State<UnivCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.univ.univName,
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

  void NavigateUnivWeb() async {

    print(Provider.of<UnivModel>(context,listen: false).univCode);

    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          // return UnivProWeb(
          //   univCode: univ.univCode,
          // );
          return ChangeNotifierProvider.value(
            value: Provider.of<UnivModel>(context),
            child: UnivProWeb(
              univCode: widget.univ.univCode,
            ),
          );
        },
      ),
    );
  }

  void deleteUniv() async {
    UnivDB univdb = UnivDB();
    await univdb.deleteInfo(widget.univ.id);
  }
}
