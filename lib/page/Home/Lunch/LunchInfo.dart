import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/page/Home/NiceApi.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import '../HomeModel.dart';
import 'Lunch.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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
    //prac();

    touchedMenu = widget.lunch.menu[0];
  }

  Future<void> prac() async {
    // 요청하기
    final Response response = await http.get(Uri.parse(
        "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/20220831_2.jpg&w=139&h=99"));

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print(response.contentLength);

      //return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (touchedMenu == "급식정보가 없습니다.") {
      return blank();
    }

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
          if (UserProfile.currentUser.code == 7530072)
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

  Widget blank() {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.lunch.date,
        style: TextStyle(color: Colors.black),
      )),
      body: Center(
          child: Text(
        "급식 정보가 없습니다.",
        style: TextStyle(fontSize: 28),
      )),
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
  Widget build(BuildContext context) {
    Name_DateMap lunchAllMap =
        Name_DateMap(Provider.of<HomeModel>(context).lunchMap);
    Map<String, List<String>> allmap = lunchAllMap.nameMap();

    List<String> DateList = allmap[widget.menu] ?? [];

    List<String> reversedList = List.from(DateList.reversed);
    print("${widget.menu}: $reversedList");

    if (reversedList.isEmpty) {
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
              child: Center(
                  child: Text(
                "오늘 처음나온 급식입니다!",
                style: TextStyle(fontSize: 24),
              ))),
        ],
      );
    }

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
            itemCount: reversedList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageCard(
                  date: reversedList[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ImageCard extends StatefulWidget {
  ImageCard({Key? key, required this.date}) : super(key: key);
  String date;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  String get url {
    DateTime curr = DateTime.parse(widget.date);
    DateTime dateTime2 = DateTime.parse('20220228');
    int diff = dateTime2.difference(curr).inHours;

    String url = "";
    if (diff > 0) {
      ///2022년도부터는 jpg이다.
      url =
          "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/${widget.date}_2.jpeg&w=139&h=99";
      // "https://puchonbuk.hs.kr/upload/l_passquery/${date}_2.jpeg";
    } else {
      url =
          "https://puchonbuk.hs.kr/phpThumb/phpThumb.php?src=/upload/l_passquery/${widget.date}_2.jpg&w=139&h=99";
      //"https://puchonbuk.hs.kr/upload/l_passquery/${date}_2.jpg";
    }
    print("${widget.date}: $url");
    return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    File? _displayImage = await _download();

    view = getImage(_displayImage);
    setState(() {});
  }

  Widget view = Skeleton(
    isLoading: true,
    skeleton: const SkeletonAvatar(
        style: SkeletonAvatarStyle(width: 150, height: 100)),
    child: Container(),
  );

  Widget getImage(File? file) {
    return file != null
        ? Image.file(file!)
        : Container(
      width: 100,
              height: 100,
          child: Center(
              child: Text("급식 사진이 업로드 되지 않았습니다.", textAlign: TextAlign.center),
            ),
        );
  }

  //File? _displayImage;

  Future<File?> _download() async {
    String _url = url;
    final response = await http.get(Uri.parse(_url));

    print(response.contentLength);

    int length = response.contentLength ?? 794;
    if (length == 794) {
      return null;
    }

    // Get the image name
    final imageName = path.basename(_url);
    // Get the document directory path
    final appDir = await path_provider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);

    // Downloading
    File imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
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
          view,
          // Container(
          //   width: 160,
          //   height: 120,
          //   child: Image.network(
          //     url,
          //     loadingBuilder: (BuildContext context, Widget child,
          //         ImageChunkEvent? loadingProgress) {
          //       if (loadingProgress == null) return child;
          //        return Skeleton(
          //         isLoading: true,
          //         skeleton: const SkeletonAvatar(
          //             style: SkeletonAvatarStyle(width: 150, height: 100)),
          //         child: Container(),
          //       );
          //     },
          //     fit: BoxFit.fitHeight,
          //     errorBuilder: (context, error, stackTrace) {
          //       // return Container();
          //       return Container(
          //         width: 100,
          //         height: 100,
          //         color: Colors.white70,
          //         child: Center(
          //           child: Text("급식 사진이 업로드 되지 않았습니다.",
          //               textAlign: TextAlign.center),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.date,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class Name_DateMap {
  Name_DateMap(Map<String, Lunch>? map) {
    _lunchMap = map;
  }

  Map<String, Lunch>? _lunchMap;

  Map<String, List<String>> nameMap() {
    Map<String, List<String>> allMap =
        {}; // ["급식이름"][20210819, 20210910, 20211005, 20211108];

    if (_lunchMap == null) {
      return {};
    }

    _lunchMap!.forEach((date, lunch) {
      if (validation(date)) {
        for (var dish in lunch.menu) {
          if (allMap[dish] == null) {
            allMap[dish] = [date];
          } else {
            allMap[dish]!.add(date);
          }
        }
      }
    });

    return allMap;
  }

  // 현재 또는 과거의 날짜인지
  bool validation(String date) {
    DateTime curr = DateTime.parse(date);
    DateTime now = DateTime.now();
    int diff = curr.difference(now).inHours; // curr - now 2021 - 2022 => -1

    return diff < 0 ? true : false;
  }
}
