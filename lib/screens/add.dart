import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'dart:convert';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  List<Map<String, dynamic>> createdPlaylists =
      []; // List to store created playlists

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
          debugPrint("No provider token found.");
          return;
        }

        final bearerToken = "Bearer ${session!.providerToken}";

        // Construct the request body
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

          // Decode the response to get playlist data
          final playlistData = json.decode(response.body);

          // If image URL is provided, upload the image for the playlist
          if (_imageUrlController.text.isNotEmpty) {
            await addImageToPlaylist(playlistData['id']);
          }

          // Add the playlist to the list of created playlists
          setState(() {
            createdPlaylists.add({
              'name': playlistData['name'],
              'description': playlistData['description'],
              'imageUrl': _imageUrlController.text,
            });
          });

          // Clear the form fields after creation
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

  Future<void> addImageToPlaylist(String playlistId) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session?.providerToken == null) {
        debugPrint("No provider token found.");
        return;
      }

      final bearerToken = "Bearer ${session!.providerToken}";

      // Fetch the image from the provided URL
      final imageResponse = await http.get(Uri.parse(_imageUrlController.text));
      if (imageResponse.statusCode == 200) {
        final base64Image = base64Encode(imageResponse.bodyBytes);

        // Upload the base64-encoded image to the playlist
        final uploadResponse = await http.put(
          Uri.parse("https://api.spotify.com/v1/playlists/$playlistId/images"),
          headers: {
            "Authorization": bearerToken,
            "Content-Type": "image/jpeg",
          },
          body: base64Decode(base64Image),
        );

        if (uploadResponse.statusCode == 202) {
          debugPrint("Playlist image added successfully!");
        } else {
          debugPrint(
              "Error adding image: Status Code ${uploadResponse.statusCode}");
        }
      } else {
        debugPrint(
            "Error fetching image from URL: ${imageResponse.statusCode}");
      }
    } catch (error) {
      debugPrint("Error in addImageToPlaylist: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Playlist"),
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
            const SizedBox(height: 32.0),
            // Display list of created playlists
            Expanded(
              child: ListView.builder(
                itemCount: createdPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = createdPlaylists[index];
                  return ListTile(
                    leading: playlist['imageUrl'].isNotEmpty
                        ? Image.network(
                            playlist['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.music_note),
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['description']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}