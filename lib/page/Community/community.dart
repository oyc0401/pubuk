import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Community/write.dart';
import 'package:flutterschool/page/Community/view.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class community extends StatefulWidget {
  community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {

  /// 로딩전 초기값
  String finalDate = '2022-01-15 00:09:27.614909';
  String firstDate = '';
  List<Widget> widgetList = [
    const SizedBox(
        height: 400, child: Center(child: CircularProgressIndicator()))
  ];
  /// 로딩전 초기값

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future readFirst() async {
    print('readFirst');
    //reset All DATA

    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      //print('처음값은');
      String firstvalue = querySnapshot.docs[0]['date'];
      print("처음 날짜: $firstvalue");
      firstDate = firstvalue;

      widgetList = [];
      widgetList.add(textWidget(
          jsonConversion(json: querySnapshot.docs[0].data() as Map)
              .changedJson()));

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
            finalDate = doc['date'];
            widgetList.add(textWidget(
                jsonConversion(json: doc.data() as Map).changedJson()));
          });
        });
    //print(docNameList);

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
        title: const Text('게시판'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const write()));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("마지막 글입니다."); //
            } else if (mode == LoadStatus.loading) {
              body = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(),
                  const Text("로딩중...")
                ],
              );
            } else if (mode == LoadStatus.failed) {
              body = const Text("로딩에 실패했습니다.");
            } else if (mode == LoadStatus.canLoading) {
              body = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_downward_rounded),
                  const Text("아래로 당겨주세요")
                ],
              );
            } else {
              body = const Text("글이 없습니다.");
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
          physics: const BouncingScrollPhysics(),
          children: [...widgetList],
        ),
      ),
    );
  }

  // 이거 나중에 밑에 있는 클래스로 이전해도 괜찮을듯
  Widget textWidget(Map json) {
    print("json2Widget");
    //print(json);

    // 시간 다루기
    DateTime dt = DateTime.parse(json['date']);
    //print("위젯 빌드 date: $dt");

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
                    builder: (context) => view(url: json['date'])));
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      Text(date,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black)),
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
                      style: const TextStyle(color: Colors.black)),
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
                            const Icon(
                              Icons.thumb_up,
                              size: 15,
                            ),
                            const Text('0'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            size: 15,
                          ),
                          const Text('0'),
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

class jsonConversion {
  /// 나중에 db에 새로운 필드가 추가될 것을 대비해서 만든 클래스

  Map json = {};

  jsonConversion({required this.json});

  Map changedJson() {
    // 인수 9개
    String ID = json['ID'] ?? 'oo';
    String text = json['text'] ?? '내용이 없습니다.';
    String userid = json['userid'] ?? '알수없는 사용자43242';
    String nickname = json['nickname'] ?? '닉네임이 없습니다32131321';
    String date = json['date'] ?? '';
    String image = json['image'] ?? '';

    String title = json['title'] ?? '제목';
    int heart = json['heart'] ?? 0;
    int comment = json['comment'] ?? 0;
    String auth = json['auth'] ?? 'student';

    final Json = {
      "ID": ID,
      "userid": userid,
      "nickname": nickname,
      "date": date,
      "text": text,
      "image": image,
      'title': title,
      'heart': heart,
      'comment': comment,
      'auth': auth,
    };

    return Json;
  }
}
