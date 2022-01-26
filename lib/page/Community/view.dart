import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/Community/write.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';

import 'comment.dart';
import 'community.dart';

class view extends StatefulWidget {
  view({Key? key, required this.url}) : super(key: key);
  String url = 'cc'; //  부모의 ID

  @override
  _viewState createState() => _viewState();
}

class _viewState extends State<view> {
  String writedComment = '241';
  Widget Context = Container();
  Widget Comment = Container();
  String id = '';
  String nickname = '';

  getProfile() async {
    SaveKey key = await SaveKey().getInstance();
    id = key.uid();
    nickname = key.nickname();
  }

  Future read() async {
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .get()
        .then((doc) {
      setState(() {
        Context = ContextWidget(
            jsonConversion(json: doc.data() as Map).changedJson());
      });
    });
  }

  Future readComment() async {
    print('댓글 불러옴');
    List<Widget> listcomment = [];

//댓글 10개 읽기
    await FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .collection('comment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        listcomment.add(
          comment(
            json: jsonConversion(json: doc.data() as Map).changedJson(),
            url: widget.url,
          ),
        );
      });
    });

    setState(() {
      Comment = Column(
        children: [...listcomment],
      );
    });
  }

  Future<void> writeComment() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .collection('comment')
        .doc(date)
        .set({
      'ID': date,
      'userid': id,
      'nickname': nickname,
      'text': writedComment,
      'url': widget.url,
      'date': date,
    }).then((value) {
      print("Comment Added");
    }).catchError((error) => print("Failed to add user: $error"));
    readComment();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    read();
    readComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              read();
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () {
              readComment();
            },
            icon: const Icon(Icons.comment),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Context,
          Row(
            children: [
              Container(
                width: 200,
                child: TextField(
                  onChanged: (text) {
                    writedComment = text;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: '댓글을 적어주세요'),
                ),
              ),
              CupertinoButton(
                  child: Text('댓글쓰기'),
                  onPressed: () {
                    writeComment();
                  })
            ],
          ),
          Comment
        ],
      ),
    );
  }

  Widget ContextWidget(Map json) {
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

    //make widget
    Widget baby = Container(
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
