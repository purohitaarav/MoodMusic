import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'add.dart';
import 'library.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> createdPlaylists = []; 
  int currentTabIndex = 0; 

  Future<void> handleDeletePlaylist(int index) async {
    final playlist = createdPlaylists[index];

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session?.providerToken == null) {
        debugPrint("No Spotify provider token found.");
        return;
      }

      final bearerToken = "Bearer ${session!.providerToken}";
      final response = await http.delete(
        Uri.parse("https://api.spotify.com/v1/playlists/${playlist['id']}/followers"),
        headers: {
          "Authorization": bearerToken,
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint("Playlist deleted successfully from Spotify.");
      } else {
        debugPrint("Failed to delete playlist from Spotify: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error deleting playlist from Spotify: $error");
    }

    setState(() {
      createdPlaylists.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: [
          const Home(),
          Add(
            onPlaylistCreated: (playlist) {
              setState(() {
                createdPlaylists.add(playlist); 
              });
            },
          ),
          Library(
            createdPlaylists: createdPlaylists, 
            onDeletePlaylist: handleDeletePlaylist,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (currentIndex) {
          setState(() {
            currentTabIndex = currentIndex; 
          });
        },
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black45,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.white),
            label: 'Add Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music, color: Colors.white),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
