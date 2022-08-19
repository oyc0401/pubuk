import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class lunchview extends StatefulWidget {
  const lunchview({Key? key}) : super(key: key);

  @override
  _lunchviewState createState() => _lunchviewState();
}

class _lunchviewState extends State<lunchview> {

  /// 전역변수
  List MenuArray = [];
  String lunchImageTitle = "뭔가 오류가 있다.";
  List? touchedDateList = ['20211122'];

  ///나중에 설정하는 변수
  late Map allMenuMap;

  @override
  void initState() {
    super.initState();
    allMenuMap = assetMap();
  }


  @override
  Widget build(BuildContext context) {
    return Container(child: SizedBox(height: 340, child: PictureView()),);
  }

  /// 사진 레이아웃
  Widget PictureView() {
    return ListView(
      children: [Text(lunchImageTitle), ...images()],
    );
  }

  /// 사진 리스트뷰 레이아웃
  List<Widget> images() {
    List<Widget> list = [];
    List todaymenu = touchedDateList!;

    //print("lunch: "+todaymenu.length.toString());
    int length = todaymenu.length;
    if (length >= 5) {
      length = 5;
    }

    for (int i = length - 1; i >= 0; i--) {
      String Date = '20210607';
      Date = todaymenu[i];

      list.add(Text(Date));

      list.add(Image.network(
        "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/$Date" +
            "_2.jpeg&w=139&h=99",
        errorBuilder: (context, error, stackTrace) => Text("급식 사진을 찾을 수 없습니다."),
      ));

      ///"https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/$Date"+"_2.jpeg&w=139&h=99"
      ///"https://puchonbuk.hs.kr/upload/l_passquery/$Date"+"_2.jpeg"

    }
    return list;
  }
  /// 저장한 json맵
  Map assetMap() {
    Map<dynamic, List> allMap =
    Map(); // ["급식이름"][20210819, 20210910, 20211005, 20211108];

    Future<String> jsonstring() async {
      String jsonString = await rootBundle.loadString('asset/a.json');
      return jsonString;
    }

    jsonstring().then((value) {
      print("lunch: 원본 급식 json 파일 가져오기 성공");

      Postasset post = Postasset.fromJson(json.decode(value));
      var Menu = post.Menu;

      //print("lunch: "+Menu.toString());

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

      //print(allMap);

      //print("여기까지 입니다.");

      allMenuMap = allMap;
      lunchImageTitle = "오른쪽에서 메뉴를 선택하면 과거에 나왔던 급식의 사진을 볼 수 있어요.";
    });
    return allMap;
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
    print("lunch: 급식 배열 길이: $listLength");
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