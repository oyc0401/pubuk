import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:provider/provider.dart';

import 'UnivModel.dart';
import 'UnivName.dart';

class UnivProWeb extends StatelessWidget {
  UnivProWeb({Key? key, required this.univCode}) : super(key: key);
  String univCode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UnivModel(
          univCode: univCode,
          year: 2023,
          univWay: UnivWay.comprehensive,
          isLike: false),
      child: Scaffold(
        appBar: SearchAppBar(),
        body: UnivWebView(),
        floatingActionButton: LikeButton(),
      ),
    );
  }
}

class UnivWebView extends StatelessWidget {
  const UnivWebView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      // contextMenu: contextMenu,
      initialUrlRequest: URLRequest(
        url: Provider.of<UnivModel>(context).uri,
      ),
      onWebViewCreated: (controller) {
        Provider.of<UnivModel>(context, listen: false)
            .setController(controller);
      },
      onLoadStart: (controller, url) {
        print(url);
      },
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({Key? key}) : super(key: key);

  Icon _icon(bool isFavorate) {
    if (isFavorate) {
      return const Icon(
        Icons.favorite,
        color: Colors.redAccent,
      );
    } else {
      return const Icon(
        Icons.favorite_border,
        color: Color(0xff191919),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        Provider.of<UnivModel>(context, listen: false).changeFavorate();
      },
      child: _icon(Provider.of<UnivModel>(context).isLike),
    );
  }
}

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  SearchAppBar({Key? key}) : super(key: key);

  final double height = 140;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      title: Column(
        children: [
          Text(
            UnivName.getUnivName(Provider.of<UnivModel>(context).univCode),
            style: TextStyle(color: Colors.black),
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

  void NavigateUnivSearch() async {
    // await Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UnivSearch(),
    //   ),
    // );
  }
}
