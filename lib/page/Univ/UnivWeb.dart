import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterschool/MyWidget/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../../DB/SettingDB.dart';
import 'WebViewSetting.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';

class UnivWeb extends StatelessWidget {
  UnivWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UnivSearch(
                  whereClick: WhereClick.web,
                ),
              ),
            ),
            icon: const Icon(
              Icons.search,
              size: 28,
              color: Color(0xff191919),
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<UnivModel>(context, listen: false).changeFavorate();
            },
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
          menu(),
        ],
      ),
      body: UnivWebView(),
      floatingActionButton: RemoteButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: NewWidget(),
    );
  }
}

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
  int? maxHight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InAppWebView(
        onScrollChanged: (controller, x, y) {
          print("x: $x, y: $y");
          if (Provider.of<UnivModel>(context, listen: false).onFloating ==
                  false &&
              y == 0) {
            print("보이기");
            Provider.of<UnivModel>(context, listen: false).showFloating();
          }

          if (maxHight != null &&
              Provider.of<UnivModel>(context, listen: false).onFloating ==
                  false &&
              (maxHight! - 2) > y) {
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
            Provider.of<UnivModel>(context, listen: false).hideFloating();
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

class RemoteButton extends StatefulWidget {
  const RemoteButton({Key? key}) : super(key: key);

  @override
  State<RemoteButton> createState() => _RemoteButtonState();
}

class _RemoteButtonState extends State<RemoteButton> {
  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  _showToast(String message) {
    fToast.removeCustomToast();

    fToast.showToast(
      child: Container(
        margin: EdgeInsets.all(32),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Color(0xffeaeaea),
        ),
        child: Text(message),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool onFloating = Provider.of<UnivModel>(context).onFloating;
    if (onFloating == false) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
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
}

enum MenuOptions {
  zoom,
  moveOriginal,
}

class menu extends StatelessWidget {
  menu({Key? key}) : super(key: key);
  BuildContext? nowcontext;

  @override
  Widget build(BuildContext context) {
    nowcontext = context;
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.zoom:
            navigateWebviewSetting(context);
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

  _onClickMove() {}

  void navigateWebviewSetting(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => WebViewSetting()),
    );
  }
}
