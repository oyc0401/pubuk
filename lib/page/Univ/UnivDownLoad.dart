import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownLoad extends StatefulWidget {
  const DownLoad({Key? key}) : super(key: key);

  @override
  State<DownLoad> createState() => _DownLoadState();
}

class _DownLoadState extends State<DownLoad> {
  Map returnMap = {};

  String text = "";

  @override
  void initState() {
    super.initState();
    //init();
    //getApi();

    getlocate();

  }

  getlocate(){


  }

getApi() async {
  LocateDownloader locateDownloader=LocateDownloader(address: "충청남도 아산시 배방읍 호서로79번길 20 (세출리, 호서대학교)", location: "127.1054328,37.3595963");
    await locateDownloader.downLoad();
    print(locateDownloader.Json);
    double dis=locateDownloader.getData();
    print(dis);

  text=locateDownloader.Json.toString();
  setState((){});
}
 

  init() async {
    for (String code in UnivName.univCodeList) {
      String name = UnivName.getUnivName(code);
      int where = name.indexOf("대학교");
      String massage = name.substring(0, where);
      print("code: $code, name: $name, massage: $massage");
      UnivData univdata = await down(massage);
      univdata.code = code;
      univdata.name=UnivName.getUnivName(code);
      returnMap["\"$code\""] = univdata.toPrint();
    }
    print(returnMap);
    text = returnMap.toString();
    setState(() {});
  }

  Future<UnivData> down(String name) async {
    UnivDownloader univDownloader =
        UnivDownloader(univName: name, univType: UnivType.main);
    await univDownloader.downLoad();
    UnivData univData = univDownloader.getData();
    print(univDownloader.Json);
    print(univData);
    return univData;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SelectableText(
          text,
          scrollPhysics: ClampingScrollPhysics(),
          toolbarOptions: ToolbarOptions(copy: true, selectAll: true,cut: true),
        ),
      ),
    );
  }
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
        "&searchSchulNm=$univName");
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
      int lenght = list.length;
      print("감지된 대학 수: $lenght");

      //assert(lenght<3, "대학 이름을 더 정확히 적어야합니다.");
      if (lenght == 1) {
        for (Map map in list) {
          univName = map['schoolName'];
          link = map['link'];
          location = map['adres'];
          break;
        }
      }else if(lenght==0){
        univName="찾을 수 없습니다.";
      }else{
        for (Map map in list) {
          univName = map['schoolName'];
          link = '링크 알 수 없습니다.';
          location = '알 수 없습니다.';
          break;
        }
      }
      // switch (univType) {
      //   case UnivType.main:
      //     for (Map map in list) {
      //       if (map['campusName'] == "본교") {
      //         univName = map['schoolName'];
      //         link = map['link'];
      //         location = map['adres'];
      //         break;
      //       }
      //     }
      //     break;
      //   case UnivType.branch:
      //     for (Map map in list) {
      //       if (map['campusName'] != "본교") {
      //         univName = map['schoolName'];
      //         link = map['link'];
      //         location = map['adres'];
      //         break;
      //       }
      //     }
      //     break;
      // }

    }

    return UnivData(
      code: "",
      name: univName,
      link: link,
      location: location,
    );
  }
}

enum UnivType { main, branch }




class LocateDownloader {
  String address;
  String location;

  LocateDownloader({
    required this.address,
    required this.location,
  });

  late Map<String, dynamic> Json;

  Future<void> downLoad() async => Json = await _getJson();

  double getData() => distanceFromJson(Json);

  Uri _MyUri() {
    Uri uri= Uri.parse("https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?"
        "query=${address}&coordinate=${"127.1054328,37.3595963"}");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {

    Uri uri=_MyUri();

    Map<String,String> headerss = {
      "X-NCP-APIGW-API-KEY-ID": "n4pidoepsw", // 개인 클라이언트 아이디
      "X-NCP-APIGW-API-KEY": "eHPmzXVvSyo6nroN43Kk3jUCguAMf8tVFti2IgmX" // 개인 시크릿 키
    };

    // 요청하기
    final Response response = await http.get(uri,headers: headerss);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("url: $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  double distanceFromJson(Map<String, dynamic> json) {
    double distance=json["addresses"]?[0]?["distance"];
    return distance;
  }
}