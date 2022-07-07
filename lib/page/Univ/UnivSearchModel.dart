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
    print("대학 검색 리스트 배치");
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

enum Locale { locationDisable, denied, deniedForever }

class UnivDistance {


  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 x");
      throw Locale.locationDisable;
    }

    permission = await geolocatorPlatform.checkPermission();
    print("현재: $permission");
    if (permission == LocationPermission.denied) {
      print("현재 거절상태");
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        print("거절");
        throw Locale.denied;
      }
      if (permission == LocationPermission.deniedForever) {
        print("영원히 거절 방금 누름");
        throw Locale.denied;
      }
    }


    if (permission == LocationPermission.deniedForever) {
      print("영원히 거절이였음");
      throw Locale.deniedForever;
    }

    print("성공");
    return await Geolocator.getCurrentPosition();
  }
}


