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
    required this.isLike,
  }) {
    _getFavorate();
  }

  String univCode;
  int year;
  UnivWay univWay;
  bool isLike;
  InAppWebViewController? webViewController;

  setController(InAppWebViewController inAppWebViewController) {
    webViewController = inAppWebViewController;
    notifyListeners();
  }

  plusYear() {
    year++;
    setUrl();
    notifyListeners();
  }

  minusYear() {
    year--;
    setUrl();
    notifyListeners();
  }

  changeUnivWay(UnivWay way) {
    univWay = way;
    setUrl();
    notifyListeners();
  }

  Future<void> setUrl() async =>
      await webViewController?.loadUrl(urlRequest: URLRequest(url: uri));

  Uri get uri {
    if (2022 <= year && year <= 2023) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${26}");
        case UnivWay.subject:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${31}");

        case UnivWay.sat:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${41}");
      }
    } else if (year == 2021) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${30}");
        case UnivWay.subject:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${31}");

        case UnivWay.sat:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${32}");
      }
    } else if (year == 2020) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemWebView.do?"
              "sch_year=${year}&univ_cd=${univCode}&iem_cd=${13}");
        case UnivWay.subject:
          return Uri.parse("https://www.google.co.kr/");

        case UnivWay.sat:
          return Uri.parse("https://www.google.co.kr/");
      }
    } else {
      return Uri.parse("https://www.google.co.kr/");
    }
  }

  _getFavorate() async {
    print("즐겨찾기를 했는지 확인중...");
    UnivDB univDB = UnivDB();
    List<UnivInfo> univList = await univDB.getInfo();
    for (UnivInfo univ in univList) {
      // 이미 즐겨찾기를 했으면
      if (univ.univCode == univCode) {
        isLike = true;
        print("즐겨찾기 O");
        return;
      }
    }
    // 즐겨찾기를 안했으면
    isLike = false;
    print("즐겨찾기 X");
  }

  changeFavorate() async {
    if (isLike) {
      await _deleteUniv();
      isLike = false;
    } else {
      await _insertUniv();
      isLike = true;
    }
    notifyListeners();
  }

  Future<void> _insertUniv() async {
    UnivDB univDB = UnivDB();
    univDB.insertInfo(UnivInfo(
        id: univCode,
        univName: UnivName.getUnivName(univCode),
        univCode: univCode,
        preference: UnivDB.lenght));
  }

  Future<void> _deleteUniv() async {
    UnivDB univDB = UnivDB();
    univDB.deleteInfo(univCode);
  }
}

enum UnivWay {
  comprehensive,
  subject,
  sat,
}
