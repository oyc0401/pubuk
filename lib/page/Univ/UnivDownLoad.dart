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

    init();

    //getlocate("경기도 부천시 호현로489번길 52 (소사본동, 서울신학대학교)");
  }

  init() async {
    List<UnivData> list = UnivName.univDatas;
    var geo = await _determinePosition();
    print("현재위치: ${geo.longitude},${geo.latitude}");
    List<Future<UnivData>> futures = [];

    for (UnivData data in list) {
      futures.add(getDatabox(
          univData: data, longitude: geo.longitude, latitude: geo.latitude));
    }

    print("거리 불러오는중...");
    List<UnivData> datas = await Future.wait(futures);

    print("결과:");
    datas.sort((UnivData a,UnivData  b) {
      return a.distance.compareTo(b.distance);
    });

    for (var value in datas) {
      print(value);
    }


  }

  Future<UnivData> getDatabox(
      {required UnivData univData,
      required double longitude,
      required double latitude}) async {
    LocateDownloader locateDownloader = LocateDownloader(
      address: univData.location,
      longitude: longitude,
      latitude: latitude,
    );
    await locateDownloader.downLoad();
    //print(locateDownloader.Json);
    double dis = locateDownloader.getData();
    univData.distance = dis;

    print("${univData.name}: ${dis / 1000}km, ${univData.location}");
    return univData;
  }

  ///
  ///
  /// 위치
  void getlocate(String address) async {
    var geo = await _determinePosition();
    print("${geo.longitude},${geo.latitude}");
    double dis = await getDistance(
        address: address, longitude: geo.longitude, latitude: geo.latitude);

    print("${dis / 1000}km");
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

  Future<double> getDistance(
      {required String address,
      required double longitude,
      required double latitude}) async {
    LocateDownloader locateDownloader = LocateDownloader(
      address: address,
      longitude: longitude,
      latitude: latitude,
    );
    await locateDownloader.downLoad();
    //print(locateDownloader.Json);
    double dis = locateDownloader.getData();
    //print(dis);

    // text = locateDownloader.Json.toString();
    // setState(() {});
    return dis;
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
      //print("url: $uri");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  double distanceFromJson(Map<String, dynamic> json) {
    List list = json["addresses"];

    if (list.isEmpty) {
      print("수정 필요");
      return 0;
    }

    double distance = list[0]?["distance"];

    return distance;
  }
}
