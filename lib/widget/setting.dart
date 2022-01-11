import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int Grade = 3;
  int Class = 10;

  @override
  void initState() {
    super.initState();
    _loadGrade();
  }

  _loadGrade() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Grade = (prefs.getInt('Grade') ?? 1);
      Class = (prefs.getInt('Class') ?? 1);
      print("grade: $Grade  class: $Class");
    });
  }

  _setGrade(String Grade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Grade', int.parse(Grade));
      this.Grade = int.parse(Grade);
      print("SharedPreferences: $Grade 저장");
    });
  }

  _setClass(String Class) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Class', int.parse(Class));
      this.Class = int.parse(Class);
      print("SharedPreferences: $Class 저장");
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
            SelectFormField(
              type: SelectFormFieldType.dropdown,
              // or can be dialog
              initialValue: Grade.toString(),
              icon: Icon(Icons.format_shapes),
              labelText: '학년',
              items: _Gradeitem,
              onChanged: (val) => _setGrade(val),
              onSaved: (val) => print(val),
            ),
            SelectFormField(
              type: SelectFormFieldType.dropdown,
              // or can be dialog
              initialValue: Class.toString(),
              icon: Icon(Icons.format_shapes),
              labelText: '반',
              items: _Classitem,
              onChanged: (val) => _setClass(val),
              onSaved: (val) => print(val),
            ),
            Text(Grade.toString()),
            Text(Class.toString()),
            TextButton(
                onPressed: () {
                  setState(() {
                    Grade = 1;
                  });
                },
                child: Text("리셋")),
          ],
        ));
  }

  final List<Map<String, dynamic>> _Gradeitem = [
    {
      'value': 1,
      'label': '1학년',
    },
    {
      'value': 2,
      'label': '2학년',
    },
    {
      'value': 3,
      'label': '3학년',
    },
  ];

  final List<Map<String, dynamic>> _Classitem = [
    {
      'value': 1,
      'label': '1반',
    },
    {
      'value': 2,
      'label': '2반',
    },
    {
      'value': 3,
      'label': '3반',
    },
    {
      'value': 4,
      'label': '4반',
    },
    {
      'value': 5,
      'label': '5반',
    },
    {
      'value': 6,
      'label': '6반',
    },
    {
      'value': 7,
      'label': '7반',
    },
    {
      'value': 8,
      'label': '8반',
    },
    {
      'value': 9,
      'label': '9반',
    },
    {
      'value': 10,
      'label': '10반',
    },
  ];
}
