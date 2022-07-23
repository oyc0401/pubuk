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

import 'DB/SettingDB.dart';
import 'Server/FirebaseAirPort.dart';
import 'firebase_options.dart';

enum AccountCondition { firstRun, noLogin, noRegister, signIn }
// dddd
Future<AccountCondition> currentCondition() async {
  Setting setting = Setting.current;
  if (setting.isFirst) {
    setting.isFirst = false;
    Setting.save(setting);
    return AccountCondition.firstRun;
  }

  // db에 있는 유저 정보를 통해 로그인인지 아닌지 확인한다.
  UserProfile localUser = UserProfile.currentUser;

  // 로그인 provider가 없으면 로그인을 하지 않은것으로 판단.
  if (localUser.provider == "") {
    return AccountCondition.noLogin;
  }

  // 여기까지 오면 로그인을 했을것이다.
  // 이제 파이어베이스에 uid에 맞는 저장소가 있는지 확인한다.
  FirebaseAirPort airPort = FirebaseAirPort(uid: localUser.uid);
  UserProfile? serverUser = await airPort.get();

  // 저장소가 없으면 로그인은 했지만 회원가입을 하지 않은것으로 판단.
  if (serverUser == null) {
    return AccountCondition.noRegister;
  } else {
    await UserProfile.save(serverUser);
    return AccountCondition.signIn;
  }
}

Future<void> Run_App() async {
  AccountCondition condition = await currentCondition();

  UserProfile localUser = UserProfile.currentUser;

  switch (condition) {
    case AccountCondition.firstRun:
      print("앱을 처음 시작했습니다.");
      runApp(MyApp(initialWidget: const CreateProfile()));
      break;
    case AccountCondition.noLogin:
      print("로그인을 하지 않았습니다. 홈 화면 이동!");
      runApp(MyApp(initialWidget: const MyHomePage()));
      break;
    case AccountCondition.noRegister:
      print("회원가입 중 입니다. 회원가입 이동!");
      runApp(MyApp(
          initialWidget:
          Register(uid: localUser.uid, provider: localUser.provider)));
      break;
    case AccountCondition.signIn:
      print("현재 uid: ${localUser.uid} 홈 화면 이동!");
      runApp(MyApp(initialWidget: const MyHomePage()));
      break;
  }
}

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

  await Run_App();
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





