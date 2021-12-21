import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int Grade = 1;
  int Class = 1;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Grade = (prefs.getInt('Grade') ?? 3);
      Class = (prefs.getInt('Class') ?? 4);
      print(Grade);
      print(Class);
    });
  }

  _setGrade(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Grade', num);
    });
  }

  _setClass(int num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Class', num);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                SelectDialog.showModal<String>(
                  context,
                  label: "학년을 선택하세요",
                  selectedValue: "$Grade학년",
                  items: List.generate(3, (index) {
                    var num = index + 1;
                    return "$num학년";
                  }),
                  onChange: (String selected) {
                    setState(() {
                      var dd = selected.split('');
                      Grade = int.parse(dd[0]);
                      _setGrade(Grade);
                    });
                  },
                  showSearchBox: false,
                );
              },
              child: Text("$Grade학년")),
          TextButton(
              onPressed: () {
                SelectDialog.showModal<String>(
                  context,
                  label: "반을 선택하세요",
                  selectedValue: "$Class반",
                  items: List.generate(10, (index) {
                    var num = index + 1;
                    return "$num반";
                  }),
                  onChange: (String selected) {
                    setState(() {
                      var dd = selected.split('');
                      Class = int.parse(dd[0]);
                      _setClass(Class);
                    });
                  },
                  showSearchBox: false,
                );
              },
              child: Text("$Class반"))
        ],
      ),
    );
  }
}
