import 'package:flutter/material.dart';

import 'Home/checkPage.dart';
import 'Home/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          label: "Favorites",
          icon: Icon(Icons.favorite),
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
      const MyHomePage(title: "학교"),
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
