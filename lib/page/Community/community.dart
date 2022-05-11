import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Server/GetFirebase.dart';
import '../../tools/Time.dart';
import 'view.dart';
import 'write.dart';

class community extends StatefulWidget {
  community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  /// 로딩전 초기값
  String finalDate = '2022-01-15 00:09:27.614909';
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
    await GetFirebase.readFirstMap().then((map) {
      String firstvalue = map['date'];
      print("처음 날짜: $firstvalue");
      widgetList = [];
      widgetList.add(textWidget(map));
      finalDate = firstvalue;
    });
  }

  Future readPage() async {
    print('readPage');
    await GetFirebase.readTexts(finalDate).then((value) {
      value.forEach((map) {
        finalDate = map['date'];
        widgetList.add(textWidget(map));
      });
    });
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


  Widget textWidget(Map json) {
    print("json2Widget");
    //print(json);

    String date=Time.timeDifferent(json['date']);

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

