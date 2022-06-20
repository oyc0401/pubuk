import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../DB/SettingDB.dart';
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

  // 즐겨찾기한 대학들
  List<UnivInfo> favorateUnives=[];
  // 현재 선택한 대학, 전형, 년도
  String univCode;
  UnivWay univWay;
  int year;
  // 웹뷰 컨트롤러
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


    if (2018 < year) {
      year--;
      if(year<=2020){
        univWay=UnivWay.comprehensive;
      }

      _setUrl();
      notifyListeners();
    }
  }

  void changeUnivWay(UnivWay way) {
    univWay = way;
    _setUrl();
    notifyListeners();
  }



  Future<void> _setUrl() async =>
      await webViewController?.loadUrl(urlRequest: URLRequest(url: uri));

  void setScale(double scale){

    InAppWebViewGroupOptions options=InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          textZoom: (scale * 100).toInt(),
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
          pageZoom: (scale),
        ));

    webViewController?.setOptions(options: options);
  }

  /// 북마크에서 사용하는 함수
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

  void changeFavorate() {
    if (ifLikeIt) {
       delete(univCode);
    } else {
       _insert(univCode);
    }
  }

  Future<void> _insert(String code) async {
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

    notifyListeners();
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
    _setUrl();
    notifyListeners();
  }


  /// url
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

  Uri get originalUri {
    if (2022 <= year && year <= 2023) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
            "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                "chkUnivList=$univCode&sch_year=$year#con${20}");

        case UnivWay.subject:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${30}");

        case UnivWay.sat:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${40}");
      }
    } else if (year == 2021) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${10}");
        case UnivWay.subject:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${20}");

        case UnivWay.sat:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${30}");
      }
    } else if (year <= 2020) {
      switch (univWay) {
        case UnivWay.comprehensive:
          return Uri.parse(
              "https://www.adiga.kr/kcue/ast/eip/eis/inf/stdptselctn/eipStdGenSlcIemCmprGnrl2.do?p_menu_id=PG-EIP-16001&"
                  "chkUnivList=$univCode&sch_year=$year#con${20}");
        case UnivWay.subject:
          return Uri.parse("https://www.google.co.kr/");

        case UnivWay.sat:
          return Uri.parse("https://www.google.co.kr/");
      }
    } else {
      return Uri.parse("https://www.google.co.kr/");
    }
  }
}

enum UnivWay {
  comprehensive,
  subject,
  sat,
}
