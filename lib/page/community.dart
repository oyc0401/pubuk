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
  List docNameList = [];
  List MAPLIST = [];
  String finalDate = '2022-01-15 00:09:27.614909';
  String firstDate = '';
  List<Widget> widgetList = [
    const SizedBox(
        height: 200, child: Center(child: CircularProgressIndicator()))
  ];

  Future getfirstDate() async {
    //reset All DATA
    docNameList = [];
    widgetList = [];

    //get firstDate;
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

      MAPLIST = [docToMap(doc: querySnapshot.docs[0]).recivedMap()];

      finalDate = firstDate;
    });
  }

  Future readPage() async {
    print('readPage');

    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .startAfter([finalDate])
        .limit(4)
        .get()
        .then((QuerySnapshot querySnapshot) {
          //print ('바로밑');
          //print (querySnapshot.docs[0]['id']);

          querySnapshot.docs.forEach((doc) {
            print(doc['date']);
            docNameList.add(doc['date']);
            finalDate = doc['date'];

            MAPLIST.add(docToMap(doc: doc).recivedMap());
          });
        });
    print(docNameList);
    //print(MAPLIST);

    setState(() {
      widgetList = _WidgetList();
    });
    _refreshController.loadComplete();
  }

  Future reset() async {
    await getfirstDate();
    await readPage();
    _refreshController.refreshCompleted();
  }

  List<Widget> _WidgetList() {
    List<Widget> valuewidgets = [];

    print("위젯을 만들기 시작합니다!");
    int lenght = docNameList.length;

    print(MAPLIST);

    for (int i = 0; i < lenght; i++) {
      // 이곳은 위젯하나를 만들때 실행되는 장소 입니다.

      // 시간 다루기
      DateTime dt = DateTime.parse(MAPLIST[i]['date']);
      print("위젯 빌드 date: $dt");

      DateTime _toDay = DateTime.now();
      Duration duration = _toDay.difference(DateTime.parse(MAPLIST[i]['date']));

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
          print('작년이예요');
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
                        Text(MAPLIST[i]['nickname'],
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
                    child: Text(MAPLIST[i]['text'],
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

      Widget example = Column(
        children: [
          GestureDetector(
            onTap: () {
              print('눌렀어');
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
                        Text(MAPLIST[i]['nickname'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black)),
                        Text(MAPLIST[i]['date'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    alignment: Alignment.centerLeft,
                    child: Text(MAPLIST[i]['text'],
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

      //return widget

      //Widget popo = Text(docNameList[i]); 테스트용 이름 리스트 baby를 popo로 바꿔봐요
      valuewidgets.add(baby);
    }

    return valuewidgets;
  }

  @override
  void initState() {
    super.initState();
    reset();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
        //header: WaterDropHeader(),
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
                children: [CupertinoActivityIndicator(), Text("로딩중...")],
              );
            } else {
              body = Text("글이 없습니다.");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: reset,
        onLoading: readPage,
        child: ListView(
          children: [
            CupertinoButton(
                child: Text('print textlist'),
                onPressed: () {
                  print(docNameList);
                }),
            CupertinoButton(
                child: Text('getfirstDate'),
                onPressed: () {
                  getfirstDate();
                }),
            CupertinoButton(
                child: Text('readpage'),
                onPressed: () {
                  readPage();
                  //print(TEXTLIST);
                }),
            CupertinoButton(
                child: Text('setstate'),
                onPressed: () {
                  setState(() {});
                }),
            ...widgetList
          ],
        ),
      ),
    );
  }
}

class docToMap {
  QueryDocumentSnapshot<Object?> doc;

  docToMap({required this.doc});

  Map recivedMap() {
    String text = doc['text'];
    String id = doc['id'];
    String nickname = doc['nickname'];
    String date = doc['date'];
    String image = doc['image'];
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
