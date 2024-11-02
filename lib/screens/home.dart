import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moodmusic_rumad/models/category.dart';
import 'package:moodmusic_rumad/services/cateory_operations.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
// Replace the old initState()
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuthenticated =
          Supabase.instance.client.auth.currentSession != null;

      if (!isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/auth');
      } else {
        spotifyApiTest(); 
      }
    });
  }

Future<void> spotifyApiTest() async {
    final bearerToken =
        "Bearer ${Supabase.instance.client.auth.currentSession!.providerToken}";
    final response =
        await http.get(Uri.parse("https://api.spotify.com/v1/me"), headers: {
      "Authorization": bearerToken,
    });



    debugPrint(response.body);

    final responseJson = json.decode(response.body);
    final userId = responseJson['id'];

    /*final createPlaylistResponse = await http.post(
        Uri.parse("https://api.spotify.com/v1/users/$userId/playlists"),
        headers: {
          "Authorization": bearerToken,
          "Content-Type": "application/json",
        },
        body: json.encode({
          "name": "This is a test Playlist",
          "description": "This playlist was created using the Spotify API",
          "public": false,
        }));

    final createResponseBody = json.decode(createPlaylistResponse.body);
    debugPrint(createResponseBody.toString());
    */
  }

  Widget createAppBar(String message) {

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 40)),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: 
            Icon(Icons.settings, color: Colors.white,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blueGrey.shade300,
            Colors.black],
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
            stops: const [0.1, 0.3])
        ),
        
        child: Column(children: [

          createAppBar('Welcome!'),

          const SizedBox(
            height: 5
            ),
        ],),
      )
    );
  }
}