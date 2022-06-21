import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/UnivPreference.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import 'UnivModel.dart';
import 'UnivSearch.dart';
import 'package:http/http.dart' as http;

class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    UnivDownloader univDownloader =
        UnivDownloader(univName: "인하", univType: UnivType.main);
    await univDownloader.downLoad();
    UnivData univData = univDownloader.getData();
    print(univDownloader.Json);
    print(univData);
  }

  @override
  Widget build(BuildContext context) {
    List<UnivInfo>? favorateUnives =
        Provider.of<UnivModel>(context).favorateUnives;
    if (favorateUnives == null) {
      return Container(
        color: Colors.white,
      );
    }

    return Scaffold(
      appBar: UnivAppBar(),
      body: Column(
        children: [
          CupertinoButton(
            child: Text("위치 수정"),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => UnivPreference()),
              );
            },
          ),
          for (UnivInfo univ in favorateUnives) UnivBar(univ: univ)
        ],
      ),
    );
  }
}

class UnivBar extends StatelessWidget {
  UnivBar({
    Key? key,
    required this.univ,
  }) : super(key: key);
  UnivInfo univ;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          backgroundImage: NetworkImage(
              "https://upload.wikimedia.org/wikipedia/commons/6/67/InhaUniversity_Emblem.jpg"),
        ),
        title: Text(
          univ.univName,
          style: TextStyle(fontSize: 24),
        ),
        trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showSelectDialog(context)),
        onTap: () => NavigateUnivWeb(context),
        subtitle: Text("24km"),
        //onLongPress: ()=> showSelectDialog(context),
      ),
    );
  }

  void showSelectDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              onPressed: () {
                Provider.of<UnivModel>(context, listen: false)
                    .delete(univ.univCode);
                Navigator.of(context).pop();
              },
              child: Text(
                "삭제",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => UnivPreference()),
                );
              },
              child: Text(
                "순서 변경",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
        titlePadding: EdgeInsets.all(8.0),
      ),
    );
  }

  void NavigateUnivWeb(BuildContext context) {
    /// webview code 변경, 시작 할 땐 2023년 으로
    Provider.of<UnivModel>(context, listen: false).univCode = univ.univCode;
    Provider.of<UnivModel>(context, listen: false).year = 2023;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: Provider.of<UnivModel>(context),
            child: UnivWeb(),
          );
        },
      ),
    );
  }
}

class UnivAppBar extends StatelessWidget with PreferredSizeWidget {
  UnivAppBar({Key? key}) : super(key: key);

  final double height = 80;
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              NavigateUnivSearch(context);
            },
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

  void NavigateUnivSearch(BuildContext context) async {
    Provider.of<UnivModel>(context, listen: false).year = 2023;
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return UnivSearch(
            whereClick: WhereClick.main,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class UnivDownloader {
  String univName;
  UnivType univType;

  UnivDownloader({
    required this.univName,
    required this.univType,
  });

  late Map<String, dynamic> Json;

  Future<void> downLoad() async => Json = await _getJson();

  UnivData getData() => univDataFromJson(Json);

  Uri _MyUri() {
    Uri uri = Uri.parse(
        "https://www.career.go.kr/cnet/openapi/getOpenApi?apiKey=42a1daf5ceb9674aa3e23b4f44b83335"
        "&svcType=api&svcCode=SCHOOL&contentType=json&gubun=univ_list&sch1=100323&sch2=100328"
        "&searchSchulNm=인하대");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    // uri값 얻고
    Uri uri = _MyUri();

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("대학정보 url: $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  UnivData univDataFromJson(Map<String, dynamic> json) {
    String link = "error";
    String location = "error";
    String univName = "error";

    List? list = json['dataSearch']?['content'];


    if (list == null) {
      print("불러오지 못했습니다.");
    } else {
      int lenght=list.length;
      print("감지된 대학 수: $lenght");

      assert(lenght<3, "대학 이름을 더 정확히 적어야합니다.");

      switch (univType) {
        case UnivType.main:
          for (Map map in list) {
            if (map['campusName'] == "본교") {
              univName = map['schoolName'];
              link = map['link'];
              location = map['adres'];
              break;
            }
          }
          break;
        case UnivType.branch:
          for (Map map in list) {
            if (map['campusName'] != "본교") {
              univName = map['schoolName'];
              link = map['link'];
              location = map['adres'];
              break;
            }
          }
          break;
      }
    }

    return UnivData(
      univname: univName,
      link: link,
      location: location,
    );
  }
}

enum UnivType { main, branch }

class UnivData {
  UnivData({
    required this.univname,
    required this.link,
    required this.location,
  });

  String univname;
  String link;
  String location;

  @override
  String toString() {
    return "univname: $univname, link: $link, location: $location";
  }
}

// // 각 요일의 날짜를 구하기
// final DateTime now = DateTime.now();
// List<String> dates = [];  // dates: [20220613, 20220614, 20220615, 20220616, 20220617]
// for (int i = 1; i <= 5; i++) {
//   dates.add(DateFormat('yyyyMMdd')
//       .format(now.add(Duration(days: -1 * now.weekday + i))));
// }
//
// // 과목이 담길 리스트를 만든다
// List<String> arrMon = [],
//     arrTue = [],
//     arrWed = [],
//     arrThu = [],
//     arrFri = [];
//
// // 이 리스트는 시간 맵이 모두 들어있는 리스트
// List? TimeList = json['hisTimetable']?[1]?['row'];
//
// if (TimeList == null) {
//   assert(json["RESULT"]?["MESSAGE"] == "해당하는 데이터가 없습니다.", "시간표 url을 불러오는 과정에서 예상치 못한 오류가 발생했습니다.");
//   String message = "데이터가 없습니다.";
//   arrMon.add(message);
//   arrTue.add(message);
//   arrWed.add(message);
//   arrThu.add(message);
//   arrFri.add(message);
// } else {
//   assert(json['hisTimetable']?[0]?['head']?[1]?['RESULT']?['MESSAGE'] ==
//       "정상 처리되었습니다.");
//
//   for (int i = 0; i < TimeList.length; i++) {
//     final String date = TimeList[i]['ALL_TI_YMD'];
//     final String subject = TimeList[i]['ITRT_CNTNT'];
//
//     if (date == dates[0]) {
//       arrMon.add(subject);
//     } else if (date == dates[1]) {
//       arrTue.add(subject);
//     } else if (date == dates[2]) {
//       arrWed.add(subject);
//     } else if (date == dates[3]) {
//       arrThu.add(subject);
//     } else if (date == dates[4]) {
//       arrFri.add(subject);
//     }
//   }
// }
