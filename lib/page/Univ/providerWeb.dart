import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterschool/MyWidget/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../../DB/SettingDB.dart';
import '../Profile/WebViewSetting.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';

BuildContext? maincontext;

class UnivProWeb extends StatelessWidget {
  UnivProWeb({Key? key, required this.univCode}) : super(key: key);
  String univCode;

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    maincontext = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 4,
        title: Text(
          UnivName.getUnivName(Provider.of<UnivModel>(context).univCode),
          style: const TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: NavigateUnivSearch,
            icon: const Icon(
              Icons.search,
              size: 28,
              color: Color(0xff191919),
            ),
          ),
          IconButton(onPressed: (){Provider.of<UnivModel>(context, listen: false).changeFavorate();}, icon: Icon(Icons.bookmark),color: Provider.of<UnivModel>(context).ifLikeIt
              ? Colors.redAccent
              : const Color(0xff191919),),
          menu(),
        ],
      ),
      body: UnivWebView(),
      floatingActionButton: RemoteButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: NewWidget(),
    );
  }



  void NavigateUnivSearch() async {
    await Navigator.pushReplacement(
      maincontext!,
      MaterialPageRoute(
        builder: (context) => UnivSearch(),
      ),
    );
  }

}

///
///

///
///
class UnivWebView extends StatelessWidget {
  UnivWebView({
    Key? key,
  }) : super(key: key);

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        textZoom: (Setting.currentSetting.webScale * 100).toInt(),
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        pageZoom: (Setting.currentSetting.webScale),
      ));
  bool isShow = true;

  int? maxHight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InAppWebView(
        onScrollChanged: (controller, x, y) {
          //print("x: $x, y: $y");
          if (Provider.of<UnivModel>(context, listen: false).onFloating ==
                  false &&
              y == 0) {
            print("보이기");
            Provider.of<UnivModel>(context, listen: false).showFloating();
          }

          if (maxHight != null &&
              Provider.of<UnivModel>(context, listen: false).onFloating ==
                  false &&
              (maxHight! - 50) > y) {
            print("보이기");
            Provider.of<UnivModel>(context, listen: false).showFloating();
          }

          //controller.setOptions(options: options);
        },
        onZoomScaleChanged: (a, b, c) {
          print("a: $a, b: $b, c: $c");
        },
        onOverScrolled: (controller, x, y, horizon, vertical) {
          // print("a: $a, b: $b, c: $c d: $d, e: $e");
          if (Provider.of<UnivModel>(context, listen: false).onFloating ==
                  true &&
              vertical == true &&
              y > 200) {
            print("숨기기");
            Provider.of<UnivModel>(context, listen: false).dissmissFloating();
            maxHight = y;
          }
        },

        onCreateWindow: (controller, a) async {
          print(a);
        },
        initialOptions: options,

        // contextMenu: contextMenu,
        initialUrlRequest: URLRequest(
          url: Provider.of<UnivModel>(context).uri,
        ),
        onWebViewCreated: (controller) {
          Provider.of<UnivModel>(context, listen: false).webViewController =
              controller;
        },
        onLoadStart: (controller, url) {
          print(url);
        },
      ),
    );
  }
}

///
///
class RemoteButton extends StatelessWidget {
  const RemoteButton({Key? key}) : super(key: key);

  Widget click() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            "학종",
            style: TextStyle(
              // fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool onFloating = Provider.of<UnivModel>(context).onFloating;
    if (onFloating == false) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(500.0),
        ),
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
                ),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false)
                      .changeUnivWay(UnivWay.comprehensive);
                },
                child: Text(
                  "학종",
                  style: TextStyle(
                      color: (Provider.of<UnivModel>(context).univWay ==
                              UnivWay.comprehensive)
                          ? Colors.blue
                          : Colors.black),
                ),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextButton(
                  onPressed: () {
                    Provider.of<UnivModel>(context, listen: false)
                        .changeUnivWay(UnivWay.subject);
                  },
                  child: Text(
                    "교과",
                    style: TextStyle(
                        color: (Provider.of<UnivModel>(context).univWay ==
                                UnivWay.subject)
                            ? Colors.blue
                            : Colors.black),
                  ),
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false)
                      .changeUnivWay(UnivWay.sat);
                },
                child: Text(
                  "정시",
                  style: TextStyle(
                      color: (Provider.of<UnivModel>(context).univWay ==
                              UnivWay.sat)
                          ? Colors.blue
                          : Colors.black),
                ),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Color(0x17B0B0B0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
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
                  Icons.navigate_next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showToast(String message) {
    Widget toast = Container(
      margin: EdgeInsets.all(32),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0xffeaeaea),
      ),
      child: Text(message),
    );
    FToast fToast = FToast();
    fToast.init(maincontext!);
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }
}

///
///
enum MenuOptions {
  zoom,
  moveOriginal,
}

class menu extends StatelessWidget {
  const menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.zoom:
            _onclickZoom();
            break;
          case MenuOptions.moveOriginal:
            _onClickMove();
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

  _onclickZoom() => navigateWebviewSetting();

  _onClickMove() {}

  void navigateWebviewSetting() async {
    await Navigator.push(
      maincontext!,
      CupertinoPageRoute(builder: (context) => WebViewSetting()),
    );
  }
}

