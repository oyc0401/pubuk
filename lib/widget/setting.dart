import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

class setting extends StatelessWidget {
  setting({Key? key}) : super(key: key);
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'boxValue',
      'label': 'Box Label',
      'icon': Icon(Icons.stop),
    },
    {
      'value': 'circleValue',
      'label': 'Circle Label',
      'icon': Icon(Icons.fiber_manual_record),
      'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': 'starValue',
      'label': 'Star Label',
      'enable': false,
      'icon': Icon(Icons.grade),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('설'),
        ),
        body: Column(
          children: [
            SelectFormField(
              type: SelectFormFieldType.dropdown,
              // or can be dialog
              initialValue: 'circle',
              icon: Icon(Icons.format_shapes),
              labelText: 'Shape',
              items: _items,
              onChanged: (val) => print(val),
              onSaved: (val) => print(val),
            )
          ],
        ));
  }
}
