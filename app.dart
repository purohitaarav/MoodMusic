import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.white),
        selectedLabelStyle: TextStyle(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black45,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Home', ),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: 'Add Playlist'),
          BottomNavigationBarItem(icon: Icon(Icons.book, color: Colors.white), label: 'Library'),
      ]),
    );
  }
}
