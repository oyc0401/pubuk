import 'package:flutter/material.dart';
import 'package:flutterschool/page/Univ/Univ.dart';
import 'package:provider/provider.dart';

import '../../DB/UnivDB.dart';
import 'UnivModel.dart';

class UnivPreference extends StatefulWidget {
  const UnivPreference({Key? key}) : super(key: key);

  @override
  State<UnivPreference> createState() => _UnivPreferenceState();
}

class _UnivPreferenceState extends State<UnivPreference> {
  @override
  Widget build(BuildContext context) {
    List<LikeUniv>? favorateUnives =
        Provider.of<UnivModel>(context).favorateUnives;

    return Scaffold(
      appBar: AppBar(title: Text("길게 눌러 위치를 변경하세요",style: TextStyle(color: Colors.black),)),
      body: succeed(favorateUnives),
    );
  }

  Widget succeed(List<LikeUniv> unives) {
    if (unives.isEmpty) {
      return const Text(
        "북마크한 대학이 없습니다.",
        style: TextStyle(color: Colors.black),
      );
    }
    return ReorderableListView(
      padding: EdgeInsets.symmetric(horizontal: 40),
      children: <Widget>[
        for (int index = 0; index < unives.length; index++)
          UnivCard(
            key: Key('$index'),
            univ: unives[index],
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        Provider.of<UnivModel>(context, listen: false)
            .changePrefer(oldIndex, newIndex);
      },
    );
  }
}

class UnivCard extends StatelessWidget {
  UnivCard({
    Key? key,
    required this.univ,
  }) : super(key: key);
  LikeUniv univ;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              univ.univName,
              style: TextStyle(fontSize: 24),
            ),
          ),

        ],
      ),
    );
  }


}

