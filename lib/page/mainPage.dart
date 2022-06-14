import 'package:flutter/material.dart';

import 'Home/home.dart';

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
          label: "home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Music",
          icon: Icon(Icons.music_note),
        ),
        BottomNavigationBarItem(
          label: "Places",
          icon: Icon(Icons.location_on),
        ),
        BottomNavigationBarItem(
          label: "News",
          icon: Icon(Icons.library_books),
        ),
      ],
    );
  }

  List _widgetOptions() {
    return [
      const Home(),
      const Text(
        'Music',
        style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
      ),
      const Text(
        'Places',
        style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
      ),
      const Text(
        'News',
        style: const TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
      ),
    ];
  }

}
