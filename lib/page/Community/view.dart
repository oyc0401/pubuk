import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../../DB/userProfile.dart';

import '../../Server/GetFirebase.dart';
import 'comment.dart';
import 'community.dart';
import 'edit.dart';

class view extends StatefulWidget {
  view({Key? key, required this.url}) : super(key: key);
  String url = 'cc'; //  부모의 ID

  @override
  _viewState createState() => _viewState();
}

class _viewState extends State<view> {
  /// 로딩전 초기값
  String writedComment = '';
  Widget Context = Container();
  Widget Comment = Container();
  Widget editButton = Container();
  Widget deleteButton = Container();
  UserProfile userData = UserProfile.guestData();
  Widget commentField = Container();
  bool isCommentFieldOpen = false;

  /// 로딩전 초기값

  getUserData() async {
    userData = await UserProfile.Get();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    readView();
    readComment();
  }

  Widget dd = IconButton(onPressed: () {}, icon: Icon(Icons.ice_skating));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물'),
        actions: [deleteButton, editButton],
      ),
      body: ListView(
        children: [
          Context,
          Container(
            height: 20,
          ),
          commentField,
          Comment
        ],
      ),
    );
  }

  Future deleteUser() async {
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .delete()
        .then((value) => print("Deleted"))
        .catchError((error) => print("Failed to delete: $error"));
  }

  Future readView() async {
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .get()
        .then((doc) {
      setState(() {
        if (userData.getUid() == doc['userid']) {
          editButton = IconButton(
            onPressed: () {
              print('넘어갑니다.');
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => edit(
                            url: widget.url,
                          )));
            },
            icon: const Icon(Icons.edit),
          );
          deleteButton = IconButton(
              onPressed: () {
                print('삭제합니다.');
                deleteUser();
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.delete));
        }

        Context = ContextWidget(jsonConversion.text(doc.data() as Map));
      });
    });
  }

  Future readComment() async {
    print('댓글 불러옴');
    List<Widget> listcomment = [];

//댓글 10개 읽기
    await GetFirebase.readComments(widget.url).then((value) {
      value.forEach((map) {
        listcomment.add(
          comment(
            json: map,
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
      'userid': userData.getUid(),
      'nickname': userData.getNickName(),
      'text': writedComment,
      'url': widget.url,
      'date': date,
    }).then((value) {
      print("Comment Added");
    }).catchError((error) => print("Failed to add user: $error"));

    readComment();
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
            padding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
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
                CupertinoButton(
                    child: Text('댓글 적기'),
                    onPressed: () {
                      touchWriteComment();
                    }),
                Spacer(),
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

  void touchWriteComment() {
    if (isCommentFieldOpen == false) {
      isCommentFieldOpen = true;
      commentField = Row(
        children: [
          Expanded(
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
                isCommentFieldOpen = false;
                commentField = Container();
                writeComment();
              })
        ],
      );
    } else {
      isCommentFieldOpen = false;
      commentField = Container();
    }

    print('댓글 열림');
    setState(() {});
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
