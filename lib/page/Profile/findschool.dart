import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:select_dialog/select_dialog.dart';

class findSchool extends StatefulWidget {
  const findSchool({Key? key}) : super(key: key);

  @override
  State<findSchool> createState() => _findSchoolState();
}

class _findSchoolState extends State<findSchool> {
  String cityCode = "J10";
  String cityName = "교육청을 선택해주세요";

  List allSchoolList = [];
  List foundList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("학교 정보 가져오기"),
      ),
      body: Column(
        children: [
          CupertinoButton(
              child: Text(cityName),
              onPressed: () {
                getSchoolsInfo(cityCode);
              }),
          TextFormField(
            onChanged: showSchools,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            //decoration: const InputDecoration(border: InputBorder.none),
          ),
          namesSection(foundList),
        ],
      ),
    );
  }

  Widget namesSection(List typedSchools) {
    List<Widget> buttons = [];

    typedSchools.forEach((element) {
      buttons.add(schoolButton(element));
    });

    return Expanded(
        child: ListView(
          children: buttons,
        ));
  }

  Widget schoolButton(String schoolName) {
    return CupertinoButton(
      child: Text(schoolName),
      onPressed: () {
        print("나의 학교는 $schoolName 이예요");
        //saveSchoolCode(SchoolCode);
      },
    );
  }

  void saveSchoolCode(int SchoolCode){
    SaveKey saveKey=SaveKey();
    saveKey.setSchoolCode(SchoolCode);
    Navigator.of(context).pop('complete');
  }

  Future<void> getSchoolsInfo(String name) async {
    await openSelectDialog(context);
    setState(() {});
    allSchoolList = await downloadSchoolInfo(cityCode);
  }

  void showSchools(String text) {
    setState(() {
      foundList = findSchools(text, allSchoolList);
    });
  }

  Future<void> openSelectDialog(BuildContext context) async {
    await SelectDialog.showModal<String>(
      context,
      label: "교육청",
      items: SchoolLocate.locates(),
      onChange: (String locate) {
        cityName = locate;
        cityCode = SchoolLocate.Locate2Code(locate);
      },
      showSearchBox: false,
    );
  }

  Future<List> downloadSchoolInfo(String code) async {
    SchoolDownloader schoolDownloader = SchoolDownloader(cityCode: code);
    return await schoolDownloader.getNameList();
  }

  List findSchools(String name, List Schools) {
    List<String> list = [];
    Timer timer = Timer.start();

    for (int i = 0; i < Schools.length; i++) {
      String element = Schools[i][0];
      if (element.contains(name)) {
        list.add(element);
      }
    }

    timer.finish();
    return list;
  }
}

class SchoolDownloader {
  String cityCode;

  SchoolDownloader({required this.cityCode});

  Uri _getUri(String locateText) {
    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/schulAflcoinfo?Key=59b8af7c4312435989470cba41e5c7a6&"
            "Type=json&pIndex=1&pSize=1000&ATPT_OFCDC_SC_CODE=$locateText");

    return uri;
  }

  Future _getJson() async {
    // uri값 얻고
    Uri uri = _getUri(cityCode);

    // 요청하기
    final Response response = await http.get(uri);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("schulAflcoinfo: 학교 json 파싱 완료 $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  List _cleanedList(Map<String, dynamic> json) {
    List CleanedList = [];
    print(json);
    if (json['schulAflcoinfo'] == null) {} else
    if (json['schulAflcoinfo'][0]['head'][1]['RESULT']['MESSAGE'] ==
        "정상 처리되었습니다.") {
      // 이 리스트는 맵이 모두 들어있는 리스트
      List MapList = json['schulAflcoinfo'][1]['row'];

      /// [lastName]을 구하는 이유는 같은 고등학교 이름이라도 일반계, 공업계, 체육계가 있기에 이름이 중복되기 때문이다.
      String lastCode = "";

      for (Map element in MapList) {
        final String schoolName = element['SCHUL_NM'];
        final String schoolCode = element['SD_SCHUL_CODE'];

        if (lastCode != schoolCode) {
          CleanedList.add([schoolName, schoolCode]);
          lastCode = schoolCode;
        }
      }
    }
    print(CleanedList);
    return CleanedList;
  }

  Future<List> getNameList() async {
    Map<String, dynamic> json = await _getJson();
    List cleanedList = _cleanedList(json);
    return cleanedList;
  }
}

class Timer {
  DateTime? _startTime;
  DateTime? _finishTime;

  Timer.start() {
    _startTime = DateTime.now();
  }

  finish() {
    _finishTime = DateTime.now();

    final difference = _finishTime!.difference(_startTime!);
    double duration = difference.inMicroseconds / 1000;
    int milliseconds = difference.inMilliseconds;
    print("$duration ms");
    print("$milliseconds ms");
  }
}

class SchoolLocate {
  static List<String> locates() {
    List<String> list = [
      "서울특별시",
      "부산광역시",
      "대구광역시",
      "인천광역시",
      "광주광역시",
      "대전광역시",
      "울산광역시",
      "세종특별자치시",
      "경기도",
      "강원도",
      "충청북도",
      "충청남도",
      "전라북도",
      "전라남도",
      "경상북도",
      "경상남도",
      "제주특별자치도",
      "재외한국학교"
    ];
    return list;
  }

  static String Locate2Code(String locate) {
    String code = "";

    switch (locate) {
      case "서울특별시":
        code = "B10";
        break;
      case "부산광역시":
        code = "C10";
        break;
      case "대구광역시":
        code = "D10";
        break;
      case "인천광역시":
        code = "E10";
        break;
      case "광주광역시":
        code = "F10";
        break;
      case "대전광역시":
        code = "G10";
        break;
      case "울산광역시":
        code = "H10";
        break;
      case "세종특별자치시":
        code = "I10";
        break;
      case "경기도":
        code = "J10";
        break;
      case "강원도":
        code = "K10";
        break;
      case "충청북도":
        code = "M10";
        break;
      case "충청남도":
        code = "N10";
        break;
      case "전라북도":
        code = "P10";
        break;
      case "전라남도":
        code = "Q10";
        break;
      case "경상북도":
        code = "R10";
        break;
      case "경상남도":
        code = "S10";
        break;
      case "제주특별자치도":
        code = "T10";
        break;
      case "재외한국학교":
        code = "V10";
        break;
    }
    return code;
  }
}
