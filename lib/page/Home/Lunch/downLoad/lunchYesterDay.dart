import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class lunchImageYesterDay extends StatefulWidget {
 const  lunchImageYesterDay({Key? key}) : super(key: key);

  @override
  State<lunchImageYesterDay> createState() => _lunchImageYesterDayState();
}

class _lunchImageYesterDayState extends State<lunchImageYesterDay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Lunchss(),
    );
  }
}



class Lunchss extends StatefulWidget {
  const Lunchss({Key? key}) : super(key: key);

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunchss> {
  /// 설정값
  final FROM_TERM = -30;
  final TO_TERM = 30;

  /// 전역변수
  List MenuArray = [];
  String lunchImageTitle = "뭔가 오류가 있다.";
  List? touchedDateList = ['20211122'];

  ///수 나중에 설정하는 변
  late Future<Postserver> post;
  late Map allMenuMap;

  @override
  void initState() {
    super.initState();
    allMenuMap=assetMap();
    post = LunchFetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Postserver>(
      future: post,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MenuArray = lunchArray(snapshot.data!.MenuMap);
          return Table(
            children: [
              TableRow(children: [
                SizedBox(
                    height: 340,
                    child: PictureView()),
                SizedBox(
                    height: 340,
                    child: MenuView()),
              ])
            ],
          );
        }
        return const SizedBox(
            height: 200, child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  /// 메뉴 레이아웃
  Widget MenuView() {
    return PageView(
      controller: PageController(
        initialPage: 30,
        keepPage: true,
      ),
      children: [...PageViewList()],
    );
  }

  /// 사진 레이아웃
  Widget PictureView() {
    return ListView(
      children: [Text(lunchImageTitle), ...images()],
    );
  }

  /// 페이지뷰 속 리스트뷰 레이아웃
  List<Widget> TextList(int index) {
    List<dynamic> StrMenuList = MenuArray[index];
    List<Widget> ColumnList = [];

    ColumnList.add(Text(StrMenuList[0]));
    for (int i = 1; i <= StrMenuList.length - 1; i++) {
      String text = StrMenuList[i];

      ColumnList.add(OutlinedButton(
          onPressed: () {
            setState(() {
              lunchImageTitle = text;

              touchedDateList = allMenuMap[text] ??['급식이 없습니다.212122112122'];
              print(touchedDateList);
            });
          },
          child: Text(text, overflow: TextOverflow.ellipsis)));
    }

    return ColumnList;
  }

  /// 페이지뷰 레이아웃
  List<Widget> PageViewList() {
    List<Widget> PageViewList = [];

    for (int i = 0; i <= MenuArray.length - 1; i++) {
      PageViewList.add(
        Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ListView(children: TextList(i))),
      );
    }

    return PageViewList;
  }

  /// 사진 리스트뷰 레이아웃
  List<Widget> images() {
    List<Widget> list = [];
    List todaymenu = touchedDateList!;

    print(todaymenu.length);
    int length = todaymenu.length;
    if (length >= 5) {
      length = 5;
    }

    for (int i = length - 1; i >= 0; i--) {
      String Date = '20210607';
      Date = todaymenu[i];

      list.add(Text(Date));

      list.add(Image.network(
        "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/$Date"+"_2.jpeg&w=139&h=99",
        errorBuilder: (context, error, stackTrace) => Text("급식 사진을 찾을 수 없습니다."),
      ));


      ///"https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/$Date"+"_2.jpeg&w=139&h=99"
      ///"https://puchonbuk.hs.kr/upload/l_passquery/$Date"+"_2.jpeg"

    }
    return list;
  }

  /// 메뉴 2차원 배열
  List lunchArray(Map menuMap) {
    //맵을 받으면 급식 2차원 배열을 리턴한다. [index][11월 22일 월요일, 오므라이스, 쑥갓어묵국, 치즈떡볶이, 수제야채튀김, 배추김치, 사과]

    List lunchArr = [];

    List menuList(String date) {
      // 날짜(yyyyMMdd)를 입력하면 그 날짜의 급식을 담은 1차원 배열을 리턴한다.

      List? list = menuMap[date];
      list ??= ["급식정보가 없습니다."];
      return list;
    }

    String weekdayEng2Kor(String weekEng) {
      String weekKor = "";

      if (weekEng == 'Sun') {
        weekKor = '일';
      } else if (weekEng == 'Mon') {
        weekKor = '월';
      } else if (weekEng == 'Tue') {
        weekKor = '화';
      } else if (weekEng == 'Wed') {
        weekKor = '수';
      } else if (weekEng == 'Thu') {
        weekKor = '목';
      } else if (weekEng == 'Fri') {
        weekKor = '금';
      } else if (weekEng == 'Sat') {
        weekKor = '토';
      }
      weekKor = "$weekKor요일";
      return weekKor;
    }
    final DateTime now = DateTime.now();
    final String fromYMD = DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    final String toYMD = DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    String plusDayYMD = fromYMD;
    DateTime addedTime = now.add(Duration(days: FROM_TERM));

    while (plusDayYMD != toYMD){
      String title = DateFormat('MM월 dd일 ').format(addedTime) + weekdayEng2Kor(DateFormat('E').format(addedTime));

      lunchArr.add([title, ...menuList(plusDayYMD)]);

      // 추가하고 날짜 하나 올려
      addedTime = addedTime.add(Duration(days: 1));
      plusDayYMD = DateFormat('yyyyMMdd').format(addedTime);
    }
    return lunchArr;
  }

  // 오른쪽
  Future<Postserver> LunchFetchPost() async {
    String firstday = "";
    String lastday = "";

    var now = new DateTime.now();
    firstday = DateFormat('yyyyMMdd').format(now.add(Duration(days: FROM_TERM)));
    lastday = DateFormat('yyyyMMdd').format(now.add(Duration(days: TO_TERM)));

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?Key=59b8af7c4312435989470cba41e5c7a6&"
            "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7530072&"
            "MLSV_FROM_YMD=$firstday&MLSV_TO_YMD=$lastday");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("급식 json 파싱 완료 $uri");
      return Postserver.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  /// 저장한 json맵
  Map assetMap() {

    Map<dynamic, List> allMap = Map(); // ["급식이름"][20210819, 20210910, 20211005, 20211108];

    Future<String> jsonstring() async {
      String jsonString = await rootBundle.loadString('assets/a.json');
      return jsonString;
    }

    jsonstring().then((value) {
      print("원본 급식 json 파일 가져오기 성공");


      Postasset post = Postasset.fromJson(json.decode(value));
      var Menu = post.Menu;

      print(Menu);

      for (int i = 0; i <= Menu.length.toInt() - 1; i++) {
        var keys = Menu.keys.toList(); // =[20321,3213,3222,20214533,20214534,]

        List menuList =
        Menu[keys[i]]; //[현미보리밥, 냉이달래된장국, 봄동겉절이, 치즈불닭, 배추김치, 크림꽈배기]

        for (int j = 0; j <= menuList.length - 1; j++) {
          List? list = allMap[menuList[j]]; //이 리스트는 이 맵안에서 이트 메뉴가 가지고있는 리스
          list ??= []; // 리스트가 비어있으면 새로 하나 만듬

          list.add(keys[i]); // 리스트에 날짜 하나 추가

          allMap[menuList[j]] = list; //다시 반납

        }
      }

      print(allMap);

      print("여기까지 입니다.");

      allMenuMap = allMap;
      lunchImageTitle = "오른쪽에서 메뉴를 선택하면 과거에 나왔던 급식의 사진을 볼 수 있어요.";
    });
    return allMap;
  }
}

// 오른쪽
class Postserver {
  final Map MenuMap; // ["20211204"][2]= 12월 4일 2번째 급식이름

  Postserver({required this.MenuMap});

  factory Postserver.fromJson(Map<String, dynamic> json) {
    List jsonlist = json["mealServiceDietInfo"][1]["row"];
    Map Lunchmenu = Map(); // ["20211204"][2]= 12월 4일 2번째 급식이름
    List<String> Menus;

    int listLength = jsonlist.length;
    print("급식 배열 길이: $listLength");
    for (int i = 0; i <= listLength - 1; i++) {
      // 날짜
      String date = jsonlist[i]["MLSV_YMD"];
      //print(date);

      // 문자열 나누기
      Menus = jsonlist[i]["DDISH_NM"].split("<br/>");

      // 코딱지 떼기
      String cleanedData;
      for (int j = 0; j <= Menus.length - 1; j++) {
        cleanedData = Menus[j].replaceAll("-북고", "");
        for (int k = 20; k != 0; k--) {
          cleanedData = cleanedData.replaceAll("$k.", "");
        }

        cleanedData = cleanedData.replaceAll(" ", "");
        cleanedData = cleanedData.replaceAll("()", "");
        Menus[j] = cleanedData;
      }

      //print(Menus);
      Lunchmenu[date] = Menus;
    }

    return Postserver(MenuMap: Lunchmenu);
  }
}



// 왼쪽
class Postasset {
  final Map Menu; // ["20211204"][2]= 12월 4일 2번째 급식이름

  Postasset({required this.Menu});

  factory Postasset.fromJson(Map<String, dynamic> json) {
    List jsonlist = json["mealServiceDietInfo"][1]["row"];
    Map Lunchmenu = Map(); // ["20211204"][2]= 12월 4일 2번째 급식이름
    List<String> Menus;

    int listLength = jsonlist.length;
    print("급식 배열 길이: $listLength");
    for (int i = 0; i <= listLength - 1; i++) {
      // 날짜
      String date = jsonlist[i]["MLSV_YMD"];
      //print(date);

      // 문자열 나누기
      Menus = jsonlist[i]["DDISH_NM"].split(" ");

      // 코딱지 떼기
      String cleanedData;
      for (int j = 0; j <= Menus.length - 1; j++) {
        cleanedData = Menus[j].replaceAll("-북고", "");
        for (int k = 20; k != 0; k--) {
          cleanedData = cleanedData.replaceAll("$k.", "");
        }
        Menus[j] = cleanedData;
      }

      //print(Menus);
      Lunchmenu[date] = Menus;
    }

    return Postasset(Menu: Lunchmenu);
  }
}
