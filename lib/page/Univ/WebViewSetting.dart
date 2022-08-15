import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DB/SettingDB.dart';
import 'Model/UnivModel.dart';

class WebViewSetting extends StatefulWidget {
  WebViewSetting({
    Key? key,
  }) : super(key: key);

  @override
  _WebViewSettingState createState() => _WebViewSettingState();
}

class _WebViewSettingState extends State<WebViewSetting> {
  Setting setting=Setting.current;

  _save() async {
    Setting.save(setting);
    Provider.of<UnivModel>(context, listen: false).setScale(setting.webScale);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('확대'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _editSection(),
          CupertinoButton(
              child: Text('초기화'),
              onPressed: () {
                setting=Setting();
                setState(() {});
              }),
          CupertinoButton(child: Text('저장'), onPressed: _save),
        ],
      ),
    );
  }

  Widget _editSection() {
    return Column(
      children: [
        SizedBox(
          height: 18,
        ),
        Text(
          'Scale: ${setting.webScale.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 15),
        ),
        _volume(),
      ],
    );
  }

  Widget _volume() {
    return Slider(
        value: setting.webScale,
        onChanged: (newScale) {
          setState(() => setting.webScale = newScale);
        },
        min: 0.0,
        max: 3.0,
        divisions: 30,
        label: "scale: ${setting.webScale.toStringAsFixed(1)}");
  }


}
