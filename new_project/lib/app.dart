import 'package:flutter/material.dart';
import 'package:new_project/add.dart';
import 'package:new_project/home.dart';
import 'package:new_project/library.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Tabs = [const Home(), const Add(), const Library()];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("Lets Build it");
    return Scaffold(
      body: Tabs[currentTabIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (currentIndex) {
            print("Current Index is $currentIndex");
            currentTabIndex = currentIndex;
            setState(() {});
          },
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          selectedLabelStyle: const TextStyle(color: Colors.white),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black45,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Colors.white),
                label: 'Add Playlist'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book, color: Colors.white), label: 'Library'),
          ]),
    );
  }
}
