import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'dart:convert';

class Add extends StatefulWidget {
  final Function(Map<String, dynamic>) onPlaylistCreated;

  const Add({super.key, required this.onPlaylistCreated});

  @override
  State<Add> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> createPlaylist() async {
    if (_formKey.currentState!.validate()) {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        if (session?.providerToken == null) {
          debugPrint("No Spotify provider token found.");
          return;
        }

        final bearerToken = "Bearer ${session!.providerToken}";

        final body = {
          "name": _nameController.text,
          "description": _descriptionController.text,
          "public": true,
        };

        // Call Spotify API to create a new playlist
        final response = await http.post(
          Uri.parse("https://api.spotify.com/v1/me/playlists"),
          headers: {
            "Authorization": bearerToken,
            "Content-Type": "application/json",
          },
          body: json.encode(body),
        );

        if (response.statusCode == 201) {
          debugPrint("Playlist created successfully!");

          final playlistData = json.decode(response.body);

          widget.onPlaylistCreated({
            'id': playlistData['id'], // Spotify playlist ID for deletion
            'name': playlistData['name'],
            'description': playlistData['description'],
            'imageUrl': _imageUrlController.text.isNotEmpty
                ? _imageUrlController.text
                : '',
          });

          _nameController.clear();
          _descriptionController.clear();
          _imageUrlController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Playlist created successfully!")),
          );
        } else {
          debugPrint(
              "Error creating playlist: Status Code ${response.statusCode}");
          debugPrint("Response body: ${response.body}");
        }
      } catch (error) {
        debugPrint("Error in createPlaylist: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Playlist", style: TextStyle(color: Colors.white,)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: "Playlist Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a playlist name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                        labelText: "Image URL (optional)"),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: createPlaylist,
                    child: const Text("Create Playlist"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
