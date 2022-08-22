import 'package:flutter/material.dart';

import 'Lunch.dart';

String allergy =
    "요리명에 표시된 번호는 알레르기를 유발할수 있는 식재료입니다 (1.난류, 2.우유, 3.메밀, 4.땅콩, 5.대두, 6.밀, 7.고등어, 8.게, 9.새우, 10.돼지고기, 11.복숭아, 12.토마토, 13.아황산염, 14.호두, 15.닭고기, 16.쇠고기, 17.오징어, 18.조개류(굴,전복,홍합 등)";

class LunchInfo extends StatelessWidget {
  LunchInfo({Key? key, required this.lunch}) : super(key: key);
  Lunch lunch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        lunch.date,
        style: TextStyle(color: Colors.black),
      )),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: menuWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: allergyWidget(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              nutrientWidget(),
              originWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("메뉴", style: TextStyle(fontSize: 28)),
        for (String text in lunch.dish) Text(text,style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Text allergyWidget() => Text(
        allergy,
        style: TextStyle(color: Color(0xff676767)),
      );

  Column nutrientWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("영양성분", style: TextStyle(fontSize: 20)),
        Text(lunch.calorie),
        for (String text in lunch.nutrient) Text(text),
      ],
    );
  }

  Column originWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("원산지", style: TextStyle(fontSize: 20)),
        for (String text in lunch.origin) Text(text),
      ],
    );
  }
}
