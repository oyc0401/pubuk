import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/Server/FireTool.dart';
import 'package:flutterschool/page/SignIn/register.dart';

import 'package:flutterschool/page/mainPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'as kakao;

import 'firebase_options.dart';

Future<void> main() async {
  print("1");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  kakao.KakaoSdk.init(nativeAppKey: '3e345bcd63a5df82971a7d52cabb73a2');
  await UserProfile.initializeUser();


  print("실행");
  //runApp(const MyApp());
  await Run_App();
  print("끄기");
  FlutterNativeSplash.remove();
}

Run_App() async {
  // 회원가입 하다가 만 상태면 회원가입 화면으로 이동한다.
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FireUser fireUser=FireUser(uid: user.uid);
    await fireUser.checkRegister(
        onExist: () {
          runApp(MyApp(
            initialWidget: MyHomePage(),
          ));
        },
        onNotExist: () {
          runApp(MyApp(
            initialWidget: register(),
          ));
        });
  } else {
    runApp(MyApp(initialWidget: MyHomePage()));
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initialWidget}) : super(key: key);
  Widget initialWidget;

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
      //home: const SignIn(),
      //home: const SwitchPage(),
      home: initialWidget,
    );
  }
}
