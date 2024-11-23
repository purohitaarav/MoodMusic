import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  final List<Map<String, dynamic>> createdPlaylists;
  final Future<void> Function(int) onDeletePlaylist; 

  const Library({
    super.key,
    required this.createdPlaylists,
    required this.onDeletePlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Library",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: createdPlaylists.isEmpty
          ? const Center(
              child: Text(
                "No playlists created yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8, 
                  mainAxisSpacing: 8, 
                  childAspectRatio: 1, 
                ),
                itemCount: createdPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = createdPlaylists[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8.0),
                          image: playlist['imageUrl'] != null &&
                                  playlist['imageUrl'].isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(playlist['imageUrl']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              playlist['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await onDeletePlaylist(index); 
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
