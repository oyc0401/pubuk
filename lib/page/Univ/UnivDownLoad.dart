import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/UnivName.dart';
import 'package:geolocator/geolocator.dart';
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

  getlocate() async {
    var geo = await _determinePosition();
    print("${geo.longitude},${geo.latitude}");
    getApi(
        address: "충청남도 아산시 배방읍 호서로79번길 20 (세출리, 호서대학교)",
        longitude: geo.longitude,
        latitude: geo.latitude);

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  getApi(
      {required String address,
      required double longitude,
      required double latitude}) async {
    LocateDownloader locateDownloader = LocateDownloader(
      address: address,
      longitude: longitude,
      latitude: latitude,
    );
    await locateDownloader.downLoad();
    print(locateDownloader.Json);
    double dis = locateDownloader.getData();
    print(dis);

    text = locateDownloader.Json.toString();
    setState(() {});
  }

  init() async {
    for (String code in UnivName.univCodeList) {
      String name = UnivName.getUnivName(code);
      int where = name.indexOf("대학교");
      String massage = name.substring(0, where);
      print("code: $code, name: $name, massage: $massage");
      UnivData univdata = await down(massage);
      univdata.code = code;
      univdata.name = UnivName.getUnivName(code);
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
          toolbarOptions:
              ToolbarOptions(copy: true, selectAll: true, cut: true),
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
      } else if (lenght == 0) {
        univName = "찾을 수 없습니다.";
      } else {
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
  double longitude;
  double latitude;

  LocateDownloader({
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  late Map<String, dynamic> Json;

  Future<void> downLoad() async => Json = await _getJson();

  double getData() => distanceFromJson(Json);

  Uri _MyUri() {
    Uri uri = Uri.parse(
        "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?"
        "query=$address&coordinate=$longitude,$latitude");
    return uri;
  }

  Future<Map<String, dynamic>> _getJson() async {
    Uri uri = _MyUri();

    Map<String, String> headerss = {
      "X-NCP-APIGW-API-KEY-ID": "n4pidoepsw",
      // 개인 클라이언트 아이디
      "X-NCP-APIGW-API-KEY": "eHPmzXVvSyo6nroN43Kk3jUCguAMf8tVFti2IgmX"
      // 개인 시크릿 키
    };

    // 요청하기
    final Response response = await http.get(uri, headers: headerss);

    // 요청 성공하면 리턴
    if (response.statusCode == 200) {
      print("url: $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  double distanceFromJson(Map<String, dynamic> json) {
    double distance = json["addresses"]?[0]?["distance"];
    return distance;
  }
}
