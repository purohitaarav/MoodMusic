import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedMood = "happy";
  String selectedGenre = "pop";
  String? selectedArtist;
  List<dynamic> tracks = [];
  List<dynamic> artists = [];
  List<dynamic> _playlistTracks =
      []; // List to store tracks added to the playlist

  final Map<String, List<double>> moodValenceRange = {
    "happy": [0.6, 1.0],
    "relaxed": [0.4, 0.6],
    "energetic": [0.7, 1.0],
    "sad": [0.0, 0.3],
    "focused": [0.3, 0.6]
  };

  final List<String> moods = [
    "happy",
    "relaxed",
    "energetic",
    "sad",
    "focused"
  ];
  final List<String> genres = [
    "pop",
    "rock",
    "hip-hop",
    "classical",
    "jazz",
    "electronic"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isAuthenticated =
          Supabase.instance.client.auth.currentSession != null;
      if (!isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/auth');
      } else {
        await fetchArtists();
        await fetchTracksByMoodGenreArtist(selectedMood, selectedGenre);
      }
    });
  }

  Future<void> fetchArtists() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session?.providerToken == null) {
        debugPrint("No provider token found.");
        return;
      }

      final bearerToken = "Bearer ${session!.providerToken}";
      final response = await http.get(
        Uri.parse(
            "https://api.spotify.com/v1/search?q=genre:$selectedGenre&type=artist&limit=10"),
        headers: {"Authorization": bearerToken},
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        setState(() {
          artists = responseJson['artists']['items'] ?? [];
          selectedArtist = artists.isNotEmpty ? artists[0]['id'] : null;
        });
      } else {
        debugPrint(
            "Error fetching artists: Status Code ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error in fetchArtists: $error");
    }
  }

  Future<void> fetchTracksByMoodGenreArtist(String mood, String genre) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session?.providerToken == null) {
        debugPrint("No provider token found.");
        return;
      }

      final bearerToken = "Bearer ${session!.providerToken}";
      final valenceRange = moodValenceRange[mood] ?? [0.5, 0.7];
      String url =
          "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=$genre&min_valence=${valenceRange[0]}&max_valence=${valenceRange[1]}";

      if (selectedArtist != null) {
        url += "&seed_artists=$selectedArtist";
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": bearerToken},
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        setState(() {
          tracks = responseJson['tracks'] ?? [];
        });
      } else {
        debugPrint("Error fetching tracks: Status Code ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error in fetchTracksByMoodGenreArtist: $error");
    }
  }

  void addToPlaylist(dynamic track) {
    setState(() {
      if (!_playlistTracks.contains(track)) {
        _playlistTracks.add(track);
      }
    });
  }

  void navigateToPlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistScreen(playlistTracks: _playlistTracks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoodMusic - Select Mood, Genre, & Artist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play),
            onPressed: navigateToPlaylist,
          ),
        ],
      ),
      body: Column(
        children: [
          // Mood dropdown
          DropdownSelection(
            label: "Mood",
            value: selectedMood,
            items: moods,
            onChanged: (value) {
              setState(() => selectedMood = value!);
              fetchTracksByMoodGenreArtist(selectedMood, selectedGenre);
            },
          ),
          // Genre dropdown
          DropdownSelection(
            label: "Genre",
            value: selectedGenre,
            items: genres,
            onChanged: (value) {
              setState(() => selectedGenre = value!);
              fetchArtists();
              fetchTracksByMoodGenreArtist(selectedMood, selectedGenre);
            },
          ),
          // Artist dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedArtist,
              items: artists.map((artist) {
                return DropdownMenuItem<String>(
                  value: artist['id'],
                  child: Text(artist['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedArtist = value);
                fetchTracksByMoodGenreArtist(selectedMood, selectedGenre);
              },
            ),
          ),
          // Track list with add button
          Expanded(
            child: tracks.isEmpty
                ? const Center(child: Text("No tracks available"))
                : ListView.builder(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return ListTile(
                        leading: Image.network(
                          track['album']['images'][0]['url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(track['name']),
                        subtitle:
                            Text("Artist: ${track['artists'][0]['name']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => addToPlaylist(track),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Playlist screen to display added tracks
class PlaylistScreen extends StatelessWidget {
  final List<dynamic> playlistTracks;

  const PlaylistScreen({super.key, required this.playlistTracks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist"),
      ),
      body: playlistTracks.isEmpty
          ? const Center(child: Text("No tracks in the playlist"))
          : ListView.builder(
              itemCount: playlistTracks.length,
              itemBuilder: (context, index) {
                final track = playlistTracks[index];
                return ListTile(
                  leading: Image.network(
                    track['album']['images'][0]['url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(track['name']),
                  subtitle: Text("Artist: ${track['artists'][0]['name']}"),
                );
              },
            ),
    );
  }
}

// Dropdown selection helper widget
class DropdownSelection extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownSelection({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item[0].toUpperCase() + item.substring(1)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}