import 'package:flutter/material.dart';
import 'package:moodmusic_rumad/screens/app.dart';
import 'package:moodmusic_rumad/screens/home.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

// 3. Create a class called AuthScreen
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void finishSigning(Session session) async {
    debugPrint(session.user.toString());
    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // On click, navigate to the MovieDetailsScreen with the movie ID
                            MyApp(),
                      ),
                    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SupaSocialsAuth(
                socialProviders: [
                  OAuthProvider.spotify,
                ],
                onSuccess: finishSigning,
                scopes: {
                  OAuthProvider.spotify:
                      "user-read-email user-read-private user-library-modify user-library-read playlist-read-private playlist-read-collaborative playlist-modify-private playlist-modify-public"
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}