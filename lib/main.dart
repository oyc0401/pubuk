import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/Server/FireTool.dart';
import 'package:flutterschool/page/SignIn/register.dart';

import 'package:flutterschool/page/mainPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

import 'firebase_options.dart';

Future<void> main() async {
  print("start");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  kakao.KakaoSdk.init(nativeAppKey: '3e345bcd63a5df82971a7d52cabb73a2');
  await UserProfile.initializeUser();

  print("runApp");
  //runApp(const MyApp());
  await Run_App();
  print("splash 끄기");
  FlutterNativeSplash.remove();
}

Run_App() async {
  UserProfile localUser = UserProfile.currentUser;

  if(localUser.provider==""){
    print("로그인을 하지 않았습니다. 홈 화면 이동...");
    runApp(MyApp(initialWidget: const MyHomePage()));
    return;
  }

  FireUser fireUser = FireUser(uid: localUser.uid);
  UserProfile? serverUser = await fireUser.getUserProfile();

  if (serverUser == null) {
    print("회원가입 중 입니다. 회원가입 이동...");
    runApp(MyApp(
        initialWidget:
            register(uid: localUser.uid, provider: localUser.provider)));
  } else {
    print("현재 uid: ${localUser.uid} 홈 화면 이동...");
    await UserProfile.saveUserInLocalDB(serverUser);
    runApp(MyApp(initialWidget: const MyHomePage()));
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initialWidget}) : super(key: key);
  Widget initialWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("main widget이 build됌");
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
      //home: const SignIn(),
      //home: const SwitchPage(),
      home: initialWidget,
    );
  }
}
