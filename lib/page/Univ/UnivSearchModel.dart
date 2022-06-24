import 'package:flutter/cupertino.dart';
import 'package:flutterschool/DB/UserSettingDB.dart';
import 'package:flutterschool/page/Univ/UnivSearch.dart';
import 'package:geolocator/geolocator.dart';

import 'UnivName.dart';

class UnivSearchModel with ChangeNotifier {
  UnivSearchModel() {
    InitUnivDatas();
  }

  List<UnivData> get unives {
    switch (_currentSort) {
      case Sort.name:
        _sortName();
        return _univDatas;
      case Sort.distance:
        _sortDis();
        return _univDatas;
    }
  }

  List<UnivData> _univDatas = [];

  Sort _currentSort = Sort.name;

  void sortUnives(Sort sort) {
    _currentSort = sort;
    notifyListeners();
  }

  void InitUnivDatas() async {
    UserSetting userSetting = UserSetting.current;
    _univDatas = UnivName.univDatasDistance(
        longitude: userSetting.longitude, latitude: userSetting.latitude);

    notifyListeners();
  }

  _sortName() {
    _univDatas.sort((UnivData a, UnivData b) {
      return a.name.compareTo(b.name);
    });
  }

  _sortDis() {
    _univDatas.sort((UnivData a, UnivData b) {
      return a.distance.compareTo(b.distance);
    });
  }
}

enum Sort {
  name,
  distance,
}

class UnivDistance {
  static save() async {
    try {
      Position position = await determinePosition();
      UserSetting.save(
        UserSetting(longitude: position.longitude, latitude: position.latitude),
      );
      print("위치 얻기 성공");
    } catch (e) {
      print("예외: $e");
      switch (e) {
        case Loca.locationDisable:
          await Geolocator.openLocationSettings();
          break;
        case Loca.denied:
          break;
        case Loca.deniedForever:
          await Geolocator.openAppSettings();
          break;
      }

      print("현재위치가 북고로 설정되었습니다.");
      UserSetting.save(UserSetting());
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 x");
      throw Loca.locationDisable;
    }

    permission = await geolocatorPlatform.checkPermission();
    print("현재: $permission");
    if (permission == LocationPermission.denied) {
      print("현재 거절상태");
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        print("거절");
        throw Loca.denied;
      }
      if (permission == LocationPermission.deniedForever) {
        print("영원히 거절 방금 누름");
        throw Loca.denied;
      }
    }


    if (permission == LocationPermission.deniedForever) {
      print("영원히 거절이였음");
      throw Loca.deniedForever;
    }

    print("성공");
    return await Geolocator.getCurrentPosition();
  }
}

enum Loca { locationDisable, denied, deniedForever }
