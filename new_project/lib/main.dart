import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Genre Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GenreSelectionPage(),
    );
  }
}

class GenreSelectionPage extends StatelessWidget {
  final List<String> genres = ['pop', 'rock', 'hip-hop', 'jazz', 'classical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Genre')),
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(genres[index].capitalize()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SpotifyPlaylistsPage(genre: genres[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SpotifyPlaylistsPage extends StatefulWidget {
  final String genre;

  const SpotifyPlaylistsPage({required this.genre});

  @override
  _SpotifyPlaylistsPageState createState() => _SpotifyPlaylistsPageState();
}

class _SpotifyPlaylistsPageState extends State<SpotifyPlaylistsPage> {
  late Future<List<dynamic>> playlists;

  @override
  void initState() {
    super.initState();
    playlists = fetchPlaylistsByGenre(widget.genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlists for ${widget.genre.capitalize()}')),
      body: Center(
        // Added Center for better visibility
        child: FutureBuilder<List<dynamic>>(
          future: playlists,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}'); // Debug log
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No playlists found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final playlist = snapshot.data![index];
                  return ListTile(
                    leading: playlist['images'].isNotEmpty
                        ? Image.network(
                            playlist['images'][0]['url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(width: 50, height: 50, child: Placeholder()),
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['description'] ?? 'No description'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchPlaylistsByGenre(String genre) async {
  try {
    final token = await fetchSpotifyToken();
    print('Token fetched: $token'); // Debug log

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/browse/categories/$genre/playlists?limit=10'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['playlists']['items'];
    } else {
      throw Exception('Failed to fetch playlists: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchPlaylistsByGenre: $e'); // Debug log
    throw Exception('Failed to fetch playlists');
  }
}

Future<String> fetchSpotifyToken() async {
  final clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  final credentials = '$clientId:$clientSecret';
  final base64Credentials = base64Encode(utf8.encode(credentials));

  final response = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {'grant_type': 'client_credentials'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['access_token'];
  } else {
    throw Exception(
        'Failed to authenticate with Spotify: ${response.statusCode}');
  }
}

// Extension method to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
