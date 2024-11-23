import 'package:flutter/material.dart';
import 'package:moodmusic_rumad/screens/app.dart';
import 'package:moodmusic_rumad/spotifyauthservice.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Supabase.initialize(
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
    url: 'https://irhaodqloxfcxhfwwula.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlyaGFvZHFsb3hmY3hoZnd3dWxhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk1NDAwNjQsImV4cCI6MjA0NTExNjA2NH0.HfQEktrET2Deyo6LYC3tFK1jHWyJsBv7VlZkGVCsBiA',
  );

  runApp(MaterialApp(
    title: 'MoodMusic',
    debugShowCheckedModeBanner: false,
    home: const AuthScreen(),
    routes: {
      '/auth': (context) => const AuthScreen(),
    },
  ));
}
