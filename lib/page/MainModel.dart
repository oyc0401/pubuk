import 'package:flutter/cupertino.dart';

class MainModel with ChangeNotifier {

  MainModel({required this.name});

  String name;

  setName(String st){name=st;
  notifyListeners();
  }

}