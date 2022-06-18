import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../../DB/SettingDB.dart';
import '../Profile/WebViewSetting.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';

class UnivProWeb extends StatelessWidget {
  UnivProWeb({Key? key, required this.univCode}) : super(key: key);
  String univCode;

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      body: UnivWebView(),
      floatingActionButton: LikeButton(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InAppWebView(
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

class LikeButton extends StatelessWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () =>
          Provider.of<UnivModel>(context, listen: false).changeFavorate(),
      child: Icon(
        Icons.favorite,
        color: Provider.of<UnivModel>(context).ifLikeIt
            ? Colors.redAccent
            : const Color(0xff191919),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  SearchAppBar({Key? key}) : super(key: key);

  final double height = 140;

  void navigateWebviewSetting() async {
    await Navigator.push(
      buildContext,
      CupertinoPageRoute(builder: (context) => WebViewSetting()),
    );
  }

  void NavigateUnivSearch() async {
    await Navigator.pushReplacement(
      buildContext,
      MaterialPageRoute(
        builder: (context) => UnivSearch(),
      ),
    );
  }

  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return AppBar(
      toolbarHeight: height,
      elevation: 4,
      title: Column(
        children: [
          Text(
            UnivName.getUnivName(Provider.of<UnivModel>(context).univCode),
            style: const TextStyle(color: Colors.black),
          ),
          Row(
            children: [
              CupertinoButton(
                  child: Text(
                    "학종",
                    style: TextStyle(
                        color: (Provider.of<UnivModel>(context).univWay ==
                                UnivWay.comprehensive)
                            ? Colors.blue
                            : Colors.black),
                  ),
                  onPressed: () {
                    Provider.of<UnivModel>(context, listen: false)
                        .changeUnivWay(UnivWay.comprehensive);
                  }),
              CupertinoButton(
                child: Text(
                  "교과",
                  style: TextStyle(
                      color: (Provider.of<UnivModel>(context).univWay ==
                              UnivWay.subject)
                          ? Colors.blue
                          : Colors.black),
                ),
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false)
                      .changeUnivWay(UnivWay.subject);
                },
              ),
              CupertinoButton(
                child: Text(
                  "정시",
                  style: TextStyle(
                      color: (Provider.of<UnivModel>(context).univWay ==
                              UnivWay.sat)
                          ? Colors.blue
                          : Colors.black),
                ),
                onPressed: () {
                  Provider.of<UnivModel>(context, listen: false)
                      .changeUnivWay(UnivWay.sat);
                },
              ),
            ],
          ),
          Row(
            children: [
              CupertinoButton(
                child: Text(
                  "<<",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () =>
                    Provider.of<UnivModel>(context, listen: false).minusYear(),
              ),
              Text(
                "${Provider.of<UnivModel>(context).year}",
                style: TextStyle(color: Colors.black),
              ),
              CupertinoButton(
                child: Text(
                  ">>",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () =>
                    Provider.of<UnivModel>(context, listen: false).plusYear(),
              ),
              Expanded(
                child: CupertinoButton(
                  child: Text("Zoom"),
                  onPressed: navigateWebviewSetting,
                ),
              ),
            ],
          ),
        ],
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
        //SampleMenu(_controller.future, widget.cookieManager),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
