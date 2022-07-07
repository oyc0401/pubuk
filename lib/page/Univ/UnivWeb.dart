import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../DB/SettingDB.dart';

import 'WebViewSetting.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';

class UnivWeb extends StatelessWidget {
  UnivWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WebModel(),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: UnivWebView(),
        floatingActionButton: RemoteButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 4,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            UnivName.getUnivName(Provider.of<UnivModel>(context).univCode),
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
            "${Provider.of<UnivModel>(context).year}",
              style: const TextStyle(
                  color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () =>
              Provider.of<UnivModel>(context, listen: false).changeFavorate(),
          icon: Provider.of<UnivModel>(context).ifLikeIt
              ? Icon(
                  Icons.bookmark,
                  color: Color(0xff191919),
                )
              : Icon(
                  Icons.bookmark_border,
                  color: Color(0xff191919),
                ),
        ),
        UnivMenu(),
      ],
    );
  }
}

class UnivWebView extends StatefulWidget {
  UnivWebView({
    Key? key,
  }) : super(key: key);

  @override
  State<UnivWebView> createState() => _UnivWebViewState();
}

class _UnivWebViewState extends State<UnivWebView> {
  @override
  dispose() {
    super.dispose();
    print("야네ㅐㄴㄷ");
    //Provider.of<UnivModel>(context, listen: false).webViewController=null;
  }

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      textZoom: (Setting.current.webScale * 100).toInt(),
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      pageZoom: (Setting.current.webScale),
    ),
  );

  int? maxHight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InAppWebView(
        initialOptions: options,
        initialUrlRequest: URLRequest(
          url: Provider.of<UnivModel>(context).uri,
        ),
        onWebViewCreated: (controller) {
          Provider.of<UnivModel>(context, listen: false).webViewController =
              controller;
        },
        onScrollChanged: (controller, x, y) {
          // print("x: $x, y: $y");

          // 이미 보여주고 있을땐 나가기
          if (Provider.of<WebModel>(context, listen: false).onFloating) {
            return;
          }

          assert(maxHight! > 0, "세로길이가 0보다 작습니다.");

          // 마지막보다 위에 있을 때 보이기
          if (maxHight != null && (maxHight! - 50) > y) {
            print("보이기 $y");
            Provider.of<WebModel>(context, listen: false).showFloating();
          }
        },
        onOverScrolled: (controller, x, y, horizon, vertical) {
          // 이미 숨기고 있을땐 나가기
          if (!Provider.of<WebModel>(context, listen: false).onFloating) {
            return;
          }

          // 밑에 닿을 때 숨기기
          if (vertical == true && y > 100) {
            print("숨기기 $y");
            Provider.of<WebModel>(context, listen: false).hideFloating();
            maxHight = y;
          }
        },
        onLoadStart: (controller, url) {
          print(url);
        },
      ),
    );
  }
}

class RemoteButton extends StatelessWidget {
  RemoteButton({Key? key}) : super(key: key);

  final FToast fToast = FToast();

  void _showToast(String message) {
    // fToast.removeCustomToast();
    //
    // fToast.showToast(
    //   child: Column(
    //     children: [
    //       Container(
    //         //margin: const EdgeInsets.only(bottom: 100),
    //         padding:
    //             const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(25.0),
    //           color: Color(0xffc2c2c2),
    //         ),
    //         child: Text(
    //           message,
    //           style: TextStyle(color: Colors.black),
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 100,
    //       ),
    //     ],
    //   ),
    //   //gravity: ToastGravity.BOTTOM,
    //   positionedToastBuilder: (context, child) {
    //     return Positioned(bottom: 50.0, left: 24.0, right: 24.0, child: child);
    //   },
    //
    //   toastDuration: const Duration(seconds: 2),
    // );
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    bool onFloating = Provider.of<WebModel>(context).onFloating;
    if (onFloating == false) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(500.0),
        ),
        color: Color(0xffffffff),
        child: Container(
          width: 340,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false).minusYear();
                  _showToast(
                      "${Provider.of<UnivModel>(context, listen: false).year}");
                },
                icon: Icon(
                  Icons.navigate_before,
                  color: Provider.of<UnivModel>(context).year > 2018
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () => Provider.of<UnivModel>(context, listen: false)
                    .changeUnivWay(UnivWay.comprehensive),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text(
                  "학종",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context, UnivWay.comprehensive),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextButton(
                  onPressed: () {
                    if (Provider.of<UnivModel>(context, listen: false).year <=
                        2020) {
                      // _showToast(
                      //     "${Provider.of<UnivModel>(context, listen: false).year}년 교과등급은 제공되지 않습니다.");
                    } else {
                      Provider.of<UnivModel>(context, listen: false)
                          .changeUnivWay(UnivWay.subject);
                    }
                  },
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "교과",
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor(context, UnivWay.subject),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (Provider.of<UnivModel>(context, listen: false).year <=
                      2020) {
                    // _showToast(
                    //     "${Provider.of<UnivModel>(context, listen: false).year}년 정시등급은 제공되지 않습니다.");
                  } else {
                    Provider.of<UnivModel>(context, listen: false)
                        .changeUnivWay(UnivWay.sat);
                  }
                },
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text(
                  "정시",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor(context, UnivWay.sat),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false).plusYear();
                  _showToast(
                      "${Provider.of<UnivModel>(context, listen: false).year}");
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: Provider.of<UnivModel>(context).year < 2023
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, UnivWay thisUnivWay) {
    switch (thisUnivWay) {
      case UnivWay.comprehensive:
        return (Provider.of<UnivModel>(context).univWay ==
                UnivWay.comprehensive)
            ? Colors.blueAccent
            : Colors.black;
      case UnivWay.subject:
      case UnivWay.sat:
        if (Provider.of<UnivModel>(context).year <= 2020) {
          return Colors.grey;
        }
        return (Provider.of<UnivModel>(context).univWay == thisUnivWay)
            ? Colors.blueAccent
            : Colors.black;
    }
  }
}

enum MenuOptions {
  zoom,
  moveOriginal,
}

class UnivMenu extends StatelessWidget {
  const UnivMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.zoom:
            navigateWebviewSetting(context);
            break;
          case MenuOptions.moveOriginal:
            _onClickMove(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.zoom,
          child: const Text('텍스트 확대'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.moveOriginal,
          child: Text('원본 url'),
        ),
      ],
    );
  }

  void _onClickMove(BuildContext context) {
    Uri uri = Provider.of<UnivModel>(context, listen: false).originalUri;
    print(uri);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void navigateWebviewSetting(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => WebViewSetting()),
    );
  }
}

class WebModel with ChangeNotifier {
  WebModel() {
    onFloating = true;
    print("sadd");
  }

  bool onFloating = true;

  /// 플로팅 버튼
  void hideFloating() {
    onFloating = false;
    notifyListeners();
  }

  void showFloating() {
    onFloating = true;
    notifyListeners();
  }
}
