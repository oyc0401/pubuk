import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutterschool/DB/UserSettingDB.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:flutterschool/page/Home/HomeModel.dart';
import 'package:flutterschool/page/Profile/CreateProfile.dart';
import 'package:flutterschool/page/Profile/ProfileModel.dart';
import 'package:flutterschool/page/SignIn/Register.dart';
import 'package:flutterschool/page/Univ/Model/UnivModel.dart';
import 'package:flutterschool/page/Univ/Model/UnivSearchModel.dart';

import 'package:flutterschool/page/mainPage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:provider/provider.dart';

import 'DB/SettingDB.dart'; //gkrry
import 'Server/FirebaseAirPort.dart';
import 'firebase_options.dart';

Future<void> main() async {
  print("앱 시작");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // 스플래시 화면 켜기
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // 파이어베이스 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 카카오 sdk 시작
  kakao.KakaoSdk.init(nativeAppKey: '3e345bcd63a5df82971a7d52cabb73a2');

  // DB 불러오기
  await UserProfile.initializeUser();
  await Setting.initializeSetting();
  await UserSetting.initializeUserSetting();

  print("초기설정 완료");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  runApp(MyApp(initialWidget: const MyHomePage()));
  //print("splash 끄기");
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initialWidget}) : super(key: key);
  Widget initialWidget;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //     create: (context) => UserModel.fromDB(UserProfile.currentUser)),
        ChangeNotifierProvider(
            create: (context) =>
                EditProfileModel.fromDB(UserProfile.currentUser)),
        ChangeNotifierProvider(create: (context) => HomeModel()),
        ChangeNotifierProvider(
            create: (context) => UnivModel(
              univCode: "0000046",
              year: 2023,
              univWay: UnivWay.subject,
            )),
        ChangeNotifierProvider(create: (context) => UnivSearchModel()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            // 2

            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 3,
            shadowColor: Color(0x67FFFFFF),
            toolbarTextStyle: TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        debugShowCheckedModeBanner: false,
        //home: const SignIn(),
        //home:  Univ(),
        home: initialWidget,
      ),
    );
  }
}

////
