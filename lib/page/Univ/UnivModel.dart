import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../DB/UnivDB.dart';
import 'UnivName.dart';

class UnivModel with ChangeNotifier {
  UnivModel({
    required this.univCode,
    required this.year,
    required this.univWay,
  }) {
    print("UnivModel 불러오는 중...");

    setList().then((value) => print("UnivModel 불러오기 완료!"));
  }

  List<UnivInfo> favorateUnives=[];
  String univCode;
  int year;
  UnivWay univWay;
  InAppWebViewController? webViewController;

  /// 처음 시작할 때
  Future<void> setList() async {
    UnivDB univ = UnivDB();

    favorateUnives = await univ.getInfo();
    for (UnivInfo element in favorateUnives) {
      print("불러오기: ${element.toMap()}");
    }
    notifyListeners();
  }

  /// Univ에서 사용하는 함수

  void changePrefer(int selectIndex, int targetIndex) {
    print("selectIndex: $selectIndex, targetIndex: $targetIndex");

    /// DB에 저장
    // preference 다시 설정
    UnivDB univ = UnivDB();
    UnivInfo selectUniv = favorateUnives[selectIndex];
    UnivInfo targetUniv = favorateUnives[targetIndex];

    // 둘이 pre 바꾸기
    int target = selectUniv.preference;

    selectUniv.preference = targetUniv.preference;
    targetUniv.preference = target;
    // 저장
    univ.updateInfo(selectUniv);
    univ.updateInfo(targetUniv);

    /// 배열 설정
    UnivInfo univInfo = favorateUnives.removeAt(selectIndex);
    favorateUnives.insert(targetIndex, univInfo);

    notifyListeners();
  }

  /// web view 에서 사용하는 함수
  void plusYear() {
    if (year < 2023) {
      year++;
      _setUrl();
      notifyListeners();
    }
  }

  void minusYear() {
    if (2019 < year) {
      year--;
      _setUrl();
      notifyListeners();
    }
  }

  void changeUnivWay(UnivWay way) {
    univWay = way;
    _setUrl();
    notifyListeners();
  }

  Uri get uri {
    if (2022 <= year && year <= 2023) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${26}");
        case UnivWay.subject:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${31}");

        case UnivWay.sat:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${41}");
      }
    } else if (year == 2021) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${30}");
        case UnivWay.subject:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${31}");

        case UnivWay.sat:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${32}");
      }
    } else if (year <= 2020) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=$year&univ_cd=$univCode&iem_cd=${13}");
        case UnivWay.subject:
          return Uri.parse("https://www.google.co.kr/");

        case UnivWay.sat:
          return Uri.parse("https://www.google.co.kr/");
      }
    } else {
      return Uri.parse("https://www.google.co.kr/");
    }
  }

  Future<void> _setUrl() async =>
      await webViewController?.loadUrl(urlRequest: URLRequest(url: uri));

  /// floatButton 에서 사용하는 함수
  bool get ifLikeIt {
    for (UnivInfo univ in favorateUnives) {
      // 이미 즐겨찾기를 했으면
      if (univ.univCode == univCode) {
        print("${UnivName.getUnivName(univCode)}: 즐겨찾기 O");
        return true;
      }
    }
    // 즐겨찾기를 안했으면
    print("${UnivName.getUnivName(univCode)}: 즐겨찾기 X");
    return false;
  }

  Future<void> changeFavorate() async {
    if (ifLikeIt) {
      await delete(univCode);
    } else {
      await insert(univCode);
    }
    notifyListeners();
  }

  Future<void> insert(String code) async {
    // 뒤에서 삽입 구조

    /// 추가해야 할 prefer 구하기
    int prefer = 0;
    if (favorateUnives.isNotEmpty) {
      prefer = favorateUnives.last.preference;
      prefer++;
    }

    /// 추가해야 할 univ 설정
    UnivInfo univ = UnivInfo(
        id: code,
        univName: UnivName.getUnivName(code),
        univCode: code,
        preference: prefer);

    /// db에 추가
    UnivDB univDB = UnivDB();
    univDB.insertInfo(univ);

    /// 배열에 추가
    favorateUnives.add(univ);
  }

  Future<void> delete(String code) async {
    // 뒤에서 삽입 구조

    UnivDB univDB = UnivDB();

    /// db에서 삭제
    univDB.deleteInfo(code);

    /// 배열에서 삭제
    for (int index = 0; index <= favorateUnives.length; index++) {
      if (favorateUnives[index].univCode == code) {
        favorateUnives.removeAt(index);
        break;
      }
    }
    notifyListeners();
  }

  /// search 에서 사용하는 함수
  Future<void> changeUnivCode(String code) async {
    univCode = code;
    notifyListeners();
  }
}

enum UnivWay {
  comprehensive,
  subject,
  sat,
}
