import 'package:flutter/cupertino.dart';
import 'package:flutterschool/DB/UserSettingDB.dart';
import 'package:flutterschool/page/Univ/UnivSearch.dart';
import 'package:geolocator/geolocator.dart';

import '../UnivName.dart';

class UnivSearchModel with ChangeNotifier {
  /// 처음 시작하면 모든 대학들을 리스트에 포함시킨다.
  UnivSearchModel() {
    setUnivDatas();
  }

  /// model 요소
  /// [currentSort] 현재 정렬 기준,
  /// [_univDatas] 현재 대학 데이터들
  Sort currentSort = Sort.name;
  List<UnivData> _univDatas = [];

  // 현재 정렬된 대학 리스트를 가져온다.
  List<UnivData> get unives {
    return sortedUnives(currentSort);
  }

  void changeSort(Sort sort) {
    currentSort = sort;
    notifyListeners();
  }

  void setUnivDatas() async {
    UserSetting userSetting = UserSetting.current;
    print("대학 검색 리스트 배치 (위도: ${userSetting.latitude}, 경도: ${userSetting.longitude})");
    _univDatas = UnivName.univDatas(
         latitude: userSetting.latitude,longitude: userSetting.longitude,);
    notifyListeners();
  }

  List<UnivData> sortedUnives(Sort sort) {
    switch (sort) {
      case Sort.name:
        _sortName();
        break;
      case Sort.distance:
        _sortDis();
        break;
    }
    return _univDatas;
  }

  void _sortName() {
    _univDatas.sort((UnivData a, UnivData b) {
      return a.name.compareTo(b.name);
    });
  }

  void _sortDis() {
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
