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
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Position geo = await _determinePosition();
    print("현재위치: ${geo.longitude},${geo.latitude}");

    univDatas = UnivDistances(longitude: geo.longitude, latitude: geo.latitude);
//     univDatas = UnivDistances(longitude: 126.7884814, latitude: 37.5190178);

    setState(() {});
  }

  List<UnivData> UnivDistances(
      {required double longitude, required double latitude}) {
    /// 거리가 포함된 대학 객체들을 얻습니다.
    List<UnivData> datas = UnivName.univDatas;

    // 거리 구하기
    GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    for (UnivData data in datas) {
      double dis = geolocatorPlatform.distanceBetween(
          latitude, longitude, data.latitude, data.longitude);
      data.distance = dis;
    }

    // 거리순 정렬
    datas.sort((UnivData a, UnivData b) {
      return a.distance.compareTo(b.distance);
    });

    return datas;
  }

  Future<Position> _determinePosition() async {
    /// 현재 위치를 구합니다.
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

  List<UnivData> univDatas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: univDatas.length,
        itemBuilder: (context, index) {
          String name = univDatas[index].name;
          double distance = univDatas[index].distance / 1000;
          String address = univDatas[index].location;
          if (address.contains("(")) {
            int where = address.indexOf(" (");
            address = address.substring(0, where);
          }

          return ListTile(
            title: Text(name),
            subtitle: Text("${distance.toStringAsFixed(2)}km, ${address}"),
          );
        },
      ),
    );
  }
}

class Distance {}
