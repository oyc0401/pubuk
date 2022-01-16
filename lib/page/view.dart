import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/edit.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class view extends StatefulWidget {
  view({Key? key, required this.url}) : super(key: key);
  String url = 'cc';

  @override
  _viewState createState() => _viewState();
}

class _viewState extends State<view> {

  String comment = '241';

  List<Widget> listcomment = [];

  Widget baby = Container();

  Widget kids = Container();

  Future read() async {
    FirebaseFirestore.instance
        .collection('pubuk')
        .doc(widget.url)
        .get()
        .then((doc) {
      // url = doc['date'];
      // print("주소: $url");
      setState(() {
        baby = json2Widget(doc.data()!);
      });
    });
  }

  Future readComment() async {
    print('댓글 불러옴');
    listcomment=[];
    //댓을 10개 읽기
    await FirebaseFirestore.instance
        .collection('comment')
        .where('url',isEqualTo: widget.url)
        .get()
        .then((QuerySnapshot querySnapshot) {
          print(widget.url);
          //print(querySnapshot.docs[0]);
      querySnapshot.docs.forEach((doc) {
        print("하이요");
        print(doc.data());


        Map ff=docToCommentMap(doc: doc).recivedMap();
        listcomment.add(json2Comment(ff));

      });
    });

    setState(() {
      kids=Column(children: [
        ...listcomment
      ],);
    });
  }

  Future<void> write() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";
    FirebaseFirestore.instance.collection('comment').doc(date).set({
      'id': "oyc0401",
      'nickname': "유찬이",
      'text': comment,
      'url': widget.url,
      'date': date,
    }).then((value) {
      print("Comment Added");
      // 창 나가기
      //Navigator.of(context).pop(true);
    }).catchError((error) => print("Failed to add user: $error"));
    readComment();
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          baby,
          Row(
            children: [
              Container(
                width: 200,
                child: TextField(
                  onChanged: (text) {
                    this.comment = text;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: '댓글을 적어주세요'),
                ),
              ),
              CupertinoButton(
                  child: Text('댓글쓰기'),
                  onPressed: () {
                    write();
                  })
            ],
          ),
          kids
        ],
      ),
    );
  }

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

  Widget json2Comment(Map json) {
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
}

class docToCommentMap {
  QueryDocumentSnapshot<Object?> doc;

  docToCommentMap({required this.doc});

  Map recivedMap() {
    String text = doc['text'];
    String id = doc['id'];
    String nickname = doc['nickname'];
    String date = doc['date'];

    Map box = {
      "id": id,
      "nickname": nickname,
      "date": date,
      "text": text,
    };

    return box;
  }
}
