import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/DB/UserSettingDB.dart';
import 'package:flutterschool/page/Univ/UnivPreference.dart';

import 'package:flutterschool/page/Univ/UnivWeb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../DB/UnivDB.dart';
import '../../DB/userProfile.dart';

import 'UnivDownLoad.dart';
import 'UnivModel.dart';
import 'UnivName.dart';
import 'UnivSearch.dart';
import 'UnivSearchModel.dart';

class Univ extends StatefulWidget {
  const Univ({Key? key}) : super(key: key);

  @override
  State<Univ> createState() => _UnivState();
}

class _UnivState extends State<Univ> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast.init(context);
  }

  bool isLocateUpdate = false;

  final FToast fToast = FToast();

  void _showToast(String message) {
    fToast.removeCustomToast();

    fToast.showToast(
      child: Column(
        children: [
          Container(
            //margin: const EdgeInsets.only(bottom: 100),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Color(0xffc2c2c2),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void save() async {
    try {
      Position position = await UnivDistance.determinePosition();
      UserSetting.save(
        UserSetting(longitude: position.longitude, latitude: position.latitude),
      );
      print("위치 얻기 성공");
      _showToast("현재 위치가 업데이트 되었습니다.");
      setState(() => isLocateUpdate = true);
    } catch (e) {
      print("예외: $e");
      switch (e) {
        case Locale.locationDisable:
          _showToast("위치 설정을 확인해주세요.");
          setState(() => isLocateUpdate = false);
          await Geolocator.openLocationSettings();
          break;
        case Locale.denied:
          _showToast("위치정보를 얻지 못했습니다.");
          setState(() => isLocateUpdate = false);
          break;
        case Locale.deniedForever:
          _showToast("앱 설정에서 위치 정보를 설정해주세요.");
          setState(() => isLocateUpdate = false);
          await Geolocator.openAppSettings();
          break;
      }

      print("현재위치가 북고로 설정되었습니다.");
      UserSetting.save(UserSetting());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UnivInfo>? favorateUnives =
        Provider.of<UnivModel>(context).favorateUnives;
    UserSetting userSetting = UserSetting.current;

    return Scaffold(
      appBar: UnivAppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: Text("선호도 수정"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => UnivPreference()),
                  );
                },
              ),
            ],
          ),
          for (UnivInfo univ in favorateUnives)
            UnivBar(
              univData: UnivName.getUnivData(
                  univCode: univ.univCode,
                  longitude: userSetting.longitude,
                  latitude: userSetting.latitude),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor:
              isLocateUpdate ? Colors.lightBlueAccent : Colors.white,
          child: Icon(
            Icons.my_location,
            color: isLocateUpdate ? Colors.black : Colors.black,
          ),
          onPressed: () => save()),
    );
  }
}

enum select { delete, positionChange }

class UnivBar extends StatelessWidget {
  UnivBar({
    Key? key,
    required this.univData,
    //required this.univ,
  }) : super(key: key);

  //UnivInfo univ;
  UnivData univData;

  Future<void> showSelectDialog(BuildContext context) async {
    switch (await showDialog<select>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, select.delete);
                },
                child: const Text("삭제", style: TextStyle(fontSize: 18)),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, select.positionChange);
                },
                child: const Text("순서 변경", style: TextStyle(fontSize: 18)),
              ),
            ],
          );
        })) {
      case select.delete:
        Provider.of<UnivModel>(context, listen: false).delete(univData.code);
        break;
      case select.positionChange:
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const UnivPreference()));
        break;
      case null:
        // dialog dismissed
        break;
    }
  }

  void NavigateUnivWeb(BuildContext context) {
    /// webview code 변경, 시작 할 땐 2023년 으로
    Provider.of<UnivModel>(context, listen: false).univCode = univData.code;
    Provider.of<UnivModel>(context, listen: false).year = 2023;

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: Provider.of<UnivModel>(context),
            child: UnivWeb(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: CircleAvatar(
        //   backgroundColor: Colors.white,
        //   radius: 24,
        //   backgroundImage: NetworkImage(
        //       "https://upload.wikimedia.org/wikipedia/commons/6/67/InhaUniversity_Emblem.jpg"),
        // ),
        title: Text(
          univData.name,
          //style: TextStyle(fontSize: 24),
        ),
        trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showSelectDialog(context)),
        onTap: () => NavigateUnivWeb(context),
        subtitle: Text("${univData.getKm()}km, ${univData.getAddress()}"),
        //onLongPress: ()=> showSelectDialog(context),
      ),
    );
  }
}

class UnivAppBar extends StatelessWidget with PreferredSizeWidget {
  UnivAppBar({Key? key}) : super(key: key);

  final double height = 80;
  UserProfile userProfile = UserProfile.currentUser;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProfile.schoolName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.normal),
          ),
          Text(
            '${userProfile.grade}학년 ${userProfile.Class}반',
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      //backgroundColor: Colors.blue,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 24, right: 8),
          child: IconButton(
            onPressed: () {
              NavigateUnivSearch(context);
            },
            icon: const Icon(
              Icons.search,
              size: 28,
              color: Color(0xff191919),
            ),
          ),
        ),
      ],
    );
  }

  void NavigateUnivSearch(BuildContext context) async {
    Provider.of<UnivModel>(context, listen: false).year = 2023;
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return UnivSearch(
            whereClick: WhereClick.main,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
