import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/edit.dart';
import 'package:flutterschool/page/view.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class community extends StatefulWidget {
  community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  List docNameList = []; //이거 지금은 필요 없는데 나중에 지워도 괜찮을듯
  String finalDate = '2022-01-15 00:09:27.614909';
  String firstDate = '';
  List<Widget> widgetList = [
    SizedBox(height: 400, child: Center(child: CircularProgressIndicator()))
  ];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future readFirst() async {
    print('readFirst');
    //reset All DATA
    docNameList = [];

    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print('처음값은');
      String firstvalue = querySnapshot.docs[0]['date'];
      print(firstvalue);
      firstDate = firstvalue;

      docNameList.add(firstvalue);
      widgetList = [];
      widgetList
          .add(json2Widget(docToReadMap(doc: querySnapshot.docs[0]).recivedMap()));

      finalDate = firstDate;
    });
  }

  Future readPage() async {
    print('readPage');

    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .startAfter([finalDate])
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print(doc['date']);
            docNameList.add(doc['date']);
            finalDate = doc['date'];
            widgetList.add(json2Widget(docToReadMap(doc: doc).recivedMap()));
          });
        });
    print(docNameList);

    setState(() {});
    _refreshController.loadComplete();
  }

  Future reset() async {
    print('reset');
    await readFirst();
    await readPage();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => edit()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("마지막 글입니다."); //
            } else if (mode == LoadStatus.loading) {
              body = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CupertinoActivityIndicator(), Text("로딩중...")],
              );
            } else if (mode == LoadStatus.failed) {
              body = Text("로딩에 실패했습니다.");
            } else if (mode == LoadStatus.canLoading) {
              body = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward_rounded),
                  Text("아래로 당겨주세요")
                ],
              );
            } else {
              body = Text("글이 없습니다.");
            }
            return Container(
              height: 50.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: reset,
        onLoading: readPage,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [...widgetList],
        ),
      ),
    );
  }

  // 이거 나중에 밑에 있는 클래스로 이전해도 괜찮을듯
  Widget json2Widget(Map json) {
    print("위젯을 추가합니다!");
    //print(json);

    // 시간 다루기
    DateTime dt = DateTime.parse(json['date']);
    print("위젯 빌드 date: $dt");

    DateTime _toDay = DateTime.now();
    Duration duration = _toDay.difference(DateTime.parse(json['date']));

    int difsec = int.parse(duration.inSeconds.toString());
    int difmin = int.parse(duration.inMinutes.toString());
    int difhour = int.parse(duration.inHours.toString());
    int difday = int.parse(duration.inDays.toString());
    String yyyy = DateFormat('yyyy').format(dt);
    String MMdd = DateFormat('M/dd').format(dt);
    String yyyyMMdd = DateFormat('yyyy.MM.dd').format(dt);

    String date = 'error: 변수 설정할 때 나오는 텍스트';
    if (difsec < 60) {
      date = '$difsec초 전';
    } else if (difmin < 60) {
      date = '$difmin분 전';
    } else if (difhour < 24) {
      date = '$difhour시간 전';
    } else if (difday < 30) {
      date = '$difday일 전';
    } else if (difday < 365) {
      date = MMdd;
      if (yyyy != DateFormat('yyyy').format(_toDay)) {
        date = yyyyMMdd;
      }
    } else {
      date = yyyyMMdd;
    }

    //make widget
    Widget baby = Column(
      children: [
        GestureDetector(
          onTap: () {
            print('눌렀어');
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        view(url: json['date'])));
          },
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(json['nickname'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      Text(date,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  alignment: Alignment.centerLeft,
                  child: Text(json['text'],
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black)),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              size: 15,
                            ),
                            Text('0'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.comment,
                            size: 15,
                          ),
                          Text('0'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 0.5,
          color: Colors.grey,
        ),
      ],
    );

    return baby;
  }
}

class docToReadMap {
  QueryDocumentSnapshot<Object?> doc;

  docToReadMap({required this.doc});

  Map recivedMap() {
    String text = doc['text'] ?? '내용이 없습니다.';
    String id = doc['id'] ?? '알수없는 사용자43242';
    String nickname = doc['nickname'] ?? '닉네임이 없습니다32131321';
    String date = doc['date'] ?? '';
    String image = doc['image'] ?? '';
    Map box = {
      "id": id,
      "nickname": nickname,
      "date": date,
      "text": text,
      "image": image
    };

    return box;
  }
}
