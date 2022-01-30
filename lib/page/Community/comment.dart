import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';

import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../../DB/UserData.dart';
import '../../DB/fireDB.dart';
import 'community.dart';

class comment extends StatefulWidget {
  comment({Key? key, required this.json, required this.url}) : super(key: key);
  Map json = {};
  String url;

  @override
  _commentState createState() => _commentState();
}

class _commentState extends State<comment> {
  /// 로딩전 초기값
  List<Widget> reply = [];
  String Writedreply = 'ff';
  UserData userData=UserData.guestData();
  /// 로딩전 초기값

  getUserData() async {
    SaveKey key = await SaveKey.Instance();
    userData=key.userData();
  }

  Future<void> writeReply() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String nowdate = "${startDate.add(Duration(milliseconds: offset))}";
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .collection('comment')
        .doc(widget.json['ID'])
        .collection('reply')
        .doc(nowdate)
        .set({
      'ID': nowdate,
      'userid': userData.uid,
      'nickname': userData.nickname,
      'text': Writedreply,
      'url': widget.json['ID'],
      'date': nowdate,
    }).then((value) {
      print("Reply Added");
    }).catchError((error) => print("Failed to add user: $error"));
    readReply();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    readReply();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text(widget.json['nickname'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black)),
                  Text(dateClean(widget.json['date']),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              alignment: Alignment.centerLeft,
              child: Text(widget.json['text'],
                  maxLines: null,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: 15,
                        ),
                        Text('3'),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.comment,
                        size: 15,
                      ),
                      Text('2'),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    onChanged: (text) {
                      Writedreply = text;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: '답글을 적어주세요'),
                  ),
                ),
                CupertinoButton(
                    child: Text('dsa'),
                    onPressed: () {
                      writeReply();
                    }),
              ],
            ),
          ],
        ),
      ),
      ...reply
    ]);
  }

  Future readReply() async {
    reply = [];
    await fireDB.readReplies(widget.url, widget.json['ID']).then((list) {
      list.forEach((map) {
        reply.add(
            ReplyWidget(map));
      });
    });

    setState(() {});
  }

  Widget ReplyWidget(Map json) {
    print("위젯을 추가합니다!");

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
    //

    //make widget
    Widget baby = Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            alignment: Alignment.centerLeft,
            child: Text(json['text'],
                maxLines: null,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black)),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 15,
                      ),
                      Text('3'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 15,
                    ),
                    Text('2'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return baby;
  }

  String dateClean(String Date) {
    DateTime dt = DateTime.parse(Date);
    DateTime _toDay = DateTime.now();
    Duration duration = _toDay.difference(DateTime.parse(Date));

    int difsec = int.parse(duration.inSeconds.toString());
    int difmin = int.parse(duration.inMinutes.toString());
    int difhour = int.parse(duration.inHours.toString());
    int difday = int.parse(duration.inDays.toString());
    String yyyy = DateFormat('yyyy').format(dt);
    String MMdd = DateFormat('M/dd').format(dt);
    String yyyyMMdd = DateFormat('yyyy.MM.dd').format(dt);

    String clean = '2';
    if (difsec < 60) {
      clean = '$difsec초 전';
    } else if (difmin < 60) {
      clean = '$difmin분 전';
    } else if (difhour < 24) {
      clean = '$difhour시간 전';
    } else if (difday < 30) {
      clean = '$difday일 전';
    } else if (difday < 365) {
      clean = MMdd;
      if (yyyy != DateFormat('yyyy').format(_toDay)) {
        clean = yyyyMMdd;
      }
    } else {
      clean = yyyyMMdd;
    }

    return clean;
  }
}
