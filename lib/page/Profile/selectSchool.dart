import 'package:flutter/material.dart';
import 'package:flutterschool/page/Profile/ProfileModel.dart';
import 'package:provider/provider.dart';

import '../../MyWidget/button.dart';

class SelectSchool extends StatefulWidget {
  const SelectSchool({Key? key}) : super(key: key);

  @override
  State<SelectSchool> createState() => _SelectSchoolState();
}

class _SelectSchoolState extends State<SelectSchool> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("학교를 선택해 주세요",style: TextStyle(color: Colors.black),),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              RoundTextButton(
                text: "부천북고등학교",
                onclick: () => select(HighSchool.pubuk),
                color: Provider.of<ProfileModel>(context, listen: false)
                            .schoolName ==
                        "부천북고등학교"
                    ? Color(0xffb4d5ff)
                    : Color(0xffeeeeee),
              ),
              SizedBox(
                height: 20,
              ),
              RoundTextButton(
                text: "도당고등학교",
                onclick: () => select(HighSchool.dodang),
                color: Provider.of<ProfileModel>(context, listen: false)
                            .schoolName ==
                        "도당고등학교"
                    ? Color(0xffb4d5ff)
                    : Color(0xffeeeeee),
              ),
              SizedBox(
                height: 20,
              ),
              RoundTextButton(
                text: "원종고등학교",
                onclick: () => select(HighSchool.wonjong),
                color: Provider.of<ProfileModel>(context, listen: false)
                            .schoolName ==
                        "원종고등학교"
                    ? Color(0xffb4d5ff)
                    : Color(0xffeeeeee),
              ),
            ],
          ),
        ));
  }

  void select(HighSchool school) {
    Provider.of<ProfileModel>(context, listen: false).setHighSchool(school);
    Navigator.of(context).pop('complete');
  }
}
