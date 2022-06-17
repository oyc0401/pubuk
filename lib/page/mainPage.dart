import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Home/home.dart';
import 'Univ/Univ.dart';
import 'Univ/UnivModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNav(),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
    );
  }

  BottomNavigationBar bottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 12,

      currentIndex: _selectedIndex,
      //현재 선택된 Index
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Univ",
          icon: Icon(Icons.library_books),
        ),
        BottomNavigationBarItem(
          label: "Music",
          icon: Icon(Icons.music_note),
        ),
        BottomNavigationBarItem(
          label: "Places",
          icon: Icon(Icons.location_on),
        ),
      ],
    );
  }

  List _widgetOptions() {
    return [
      const Home(),
      ChangeNotifierProvider(
        create: (context) => UnivModel(
            univCode: "0000046",
            year: 2023,
            univWay: UnivWay.subject,
            isLike: false),
        child: MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 3,
              shadowColor: Color(0x67FFFFFF),
              toolbarTextStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          home: const Univ(),
        ),
      ),

      const Text(
        'Music',
        style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
      ),
      const Text(
        'Places',
        style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
      ),
    ];
  }
}
