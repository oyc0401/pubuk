import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Home/Lunch/downLoad/LunchSearch.dart';

import 'AllMap.dart';
import 'Lunch.dart';
import 'downLoad/lunchYesterDay.dart';

const String allergy = "요리명에 표시된 번호는 알레르기를 유발할수 있는 식재료입니다 "
    "(1.난류, 2.우유, 3.메밀, 4.땅콩, 5.대두, 6.밀, 7.고등어, 8.게, 9.새우, 10.돼지고기, 11.복숭아, 12.토마토,"
    " 13.아황산염, 14.호두, 15.닭고기, 16.쇠고기, 17.오징어, 18.조개류(굴,전복,홍합 등)";

class LunchInfo extends StatefulWidget {
  LunchInfo({Key? key, required this.lunch}) : super(key: key);
  Lunch lunch;

  @override
  State<LunchInfo> createState() => _LunchInfoState();
}

class _LunchInfoState extends State<LunchInfo> {
  String touchedMenu = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    touchedMenu = widget.lunch.menu[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.lunch.date,
        style: TextStyle(color: Colors.black),
      )),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: menuWidget(),
          ),
          LunchImage(
            menu: touchedMenu,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: allergyWidget(),
          ),
          // CupertinoButton(
          //     child: Text("검색창 이동"),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         CupertinoPageRoute(
          //           builder: (context) => const LunchSearch(),
          //         ),
          //       );
          //     }),
          // CupertinoButton(
          //     child: Text("예전 위젯 이동"),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         CupertinoPageRoute(
          //           builder: (context) => const lunchImageYesterDay(),
          //         ),
          //       );
          //     }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: nutrientWidget()),
                Expanded(child: originWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("메뉴", style: TextStyle(fontSize: 28)),
        for (int i = 0; i < widget.lunch.menu.length; i++)
          InkWell(
            onTap: () {
              touchedMenu = widget.lunch.menu[i];
              setState(() {
                print(touchedMenu);
              });
            },
            child: Text(
              widget.lunch.dish[i],
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Text allergyWidget() => Text(
        allergy,
        style: TextStyle(color: Color(0xff676767)),
      );

  Column nutrientWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("영양성분", style: TextStyle(fontSize: 20)),
        Text(widget.lunch.calorie),
        for (String text in widget.lunch.nutrient) Text(text),
      ],
    );
  }

  Column originWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("원산지", style: TextStyle(fontSize: 20)),
        for (String text in widget.lunch.origin) Text(text),
      ],
    );
  }
}

class LunchImage extends StatefulWidget {
  LunchImage({Key? key, required this.menu}) : super(key: key);

  String menu;

  @override
  State<LunchImage> createState() => _LunchImageState();
}

class _LunchImageState extends State<LunchImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    allmap = await LunchAllMap.assetMap();
    setState(() {});
  }

  Map<String, List<String>> allmap = {};

  @override
  Widget build(BuildContext context) {
    List<String> list = allmap[widget.menu] ?? [];
    return Column(
      children: [
        Center(
            child: Text(
          widget.menu,
          style: TextStyle(fontSize: 24),
        )),
        Container(
          height: 200,
          margin: EdgeInsets.all(8.0),
          color: Colors.white,
          child: ListView.builder(
            //initialScrollIndex: 5, // 0 1 2 3 4 , 5, 6 7 8 9 10
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageCard(
                  date: list[index],
                ),
              );
            },
          ),
        ),
      ],
    );

    // list.add(Image.network(
    //   "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/$Date"+"_2.jpeg&w=139&h=99",
    //   errorBuilder: (context, error, stackTrace) => Text("급식 사진을 찾을 수 없습니다."),
    // ));
  }
}

class ImageCard extends StatelessWidget {
  ImageCard({Key? key, required this.date}) : super(key: key);
  String date;

  @override
  Widget build(BuildContext context) {
    DateTime curr = DateTime.parse(date);
    DateTime dateTime2 = DateTime.parse('20220228');
    int diff = dateTime2.difference(curr).inHours;
    print(diff);
    String url = "";
    if (diff > 0) {
      ///2022년도부터는 jpg이다.
      url =
          //  "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/${date}_2.jpeg&w=139&h=99";
          "https://puchonbuk.hs.kr/upload/l_passquery/${date}_2.jpeg";
    } else {
      url =
          //   "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/${date}_2.jpg&w=139&h=99";
          "https://puchonbuk.hs.kr/upload/l_passquery/${date}_2.jpg";
    }

    print(url);
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffc4c4c4)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white),
      width: 200,
      height: 150,
      child: Column(
        children: [
          Container(
            width: 160,
            height: 120,
            child: Image.network(
              url,

              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 100,
                  height: 100,
                  // color: Colors.redAccent,
                );
              },
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                // return Container();
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.white70,
                  child: Center(
                    child: Text("급식 사진이 업로드 되지 않았습니다."),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              date,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
