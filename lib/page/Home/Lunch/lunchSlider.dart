import 'package:flutter/material.dart';
import 'package:flutterschool/page/Home/HomeModel.dart';
import 'package:flutterschool/page/Home/Lunch/LunchInfo.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skeletons/skeletons.dart';
import 'Lunch.dart';

const int FROM_TERM = -30;
const int TO_TERM = 30;

class LunchBuilder extends StatelessWidget {
  const LunchBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Lunch>? lunches = Provider.of<HomeModel>(context).lunches;

    if (lunches == null) {
      return const SkeletonScroll();
    } else {
      return LunchScroll(lunches: lunches);
    }
  }
}

class LunchScroll extends StatelessWidget {
  /// Lunch 배열로 만드는 스크롤 위젯

  List<Lunch> lunches;

  LunchScroll({
    Key? key,
    required this.lunches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: -FROM_TERM, // 0 ~ 29, 30, 31~60 <= 총 61개
        scrollDirection: Axis.horizontal,
        itemCount: -FROM_TERM + 1 + TO_TERM,
        itemBuilder: (context, index) {
          return LunchContainer(
            lunch: lunches[index],
            light: index == -FROM_TERM,
          );
        },
      ),
    );
  }
}

class LunchContainer extends StatelessWidget {
  /// Lunch 사각형 박스 객체
  /// skeleton 설정도 가능하다.

  Lunch lunch;
  bool light;
  bool isSkeleton;

  LunchContainer({
    Key? key,
    required this.lunch,
    this.isSkeleton = false,
    this.light = false,
  }) : super(key: key);

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(lunch);
        Navigator.of(context).push(createRoute(LunchInfo(lunch: lunch)));

      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(
                color: light ? Color(0xff8cc2ff) : Color(0xffc4c4c4)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white),
        child: Column(
          children: [titleSection(), foodSection()],
        ),
      ),
    );
  }

  Widget titleSection() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: skeletonText(lunch.date),
    );
  }

  Widget foodSection() {
    List<Widget> list = [];

    for (String text in lunch.menu) {
      list.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: skeletonText(text),
      ));
    }

    return Column(
      children: list,
    );
  }

  Widget skeletonText(String text) {
    return Skeleton(
      isLoading: isSkeleton,
      skeleton: const Padding(
        padding: EdgeInsets.all(3.0),
        child:
            SkeletonAvatar(style: SkeletonAvatarStyle(width: 100, height: 14)),
      ),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}

class SkeletonScroll extends StatelessWidget {
  const SkeletonScroll({Key? key}) : super(key: key);

  /// skeleton 스크롤 위젯

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: 5, // 0 1 2 3 4 , 5, 6 7 8 9 10
        scrollDirection: Axis.horizontal,
        itemCount: 11,
        itemBuilder: (context, index) {
          return LunchContainer(
            lunch: Lunch.blank(),
            light: index == 5,
            isSkeleton: true,
          );
        },
      ),
    );
  }
}
