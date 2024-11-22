import 'package:flutter/material.dart';
import 'package:moodmusic_rumad/screens/add.dart';
import 'package:moodmusic_rumad/screens/home.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
final Tabs = [const Home(), const Add()];
int currentTabIndex = 0;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuthenticated =
          Supabase.instance.client.auth.currentSession != null;
          print('Ur in');
      if (!isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/auth');
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Tabs[currentTabIndex],

      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentTabIndex,
        onTap: (currentIndex) {
          currentTabIndex = currentIndex;
          setState(() {
            
          });
        },

        unselectedLabelStyle: const TextStyle(color: Colors.white),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black45,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white), label: 'Home', ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.white), label: 'Add Playlist'),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.white), label: 'Library'),
      ]),
    );
  }
}
