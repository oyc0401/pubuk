import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterschool/DB/saveKey.dart';
import 'package:flutterschool/page/Home/home.dart';
import 'package:flutterschool/page/SignIn/register.dart';
import 'package:flutterschool/page/SignIn/searchSchool.dart';
import 'package:flutterschool/page/mainPage.dart';
import 'package:flutterschool/page/switch.dart';

import 'firebase_options.dart';
import 'page/Home/checkPage.dart';
import 'page/Profile/findschool.dart';
import 'page/SignIn/SignIn.dart';

Future<void> main() async {
  print("1");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("실행");
  runApp(const MyApp());
print("끄기");
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
    // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const register(),
      //home: const SwitchPage(),
      home: MyHomePage(title: '학교'),
    );
  }


}
