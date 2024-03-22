import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artiste.dart';
import '../services/spotify_service.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Artiste> _searchResults = [];

  void _searchArtists(String query) async {
    if (query.isNotEmpty) {
      final spotifyService = Provider.of<SpotifyService>(context, listen: false);
      List<Artiste> results = await spotifyService.fetchArtistsByName(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search artists...',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchArtists,
            ),
          ),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No results to display'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final artiste = _searchResults[index];
                return ListTile(
                  leading: artiste.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(artiste.imageUrl!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(artiste.name),
                  onTap: () {
                    print('Artiste ID: ${artiste.id}');
                    // Navigation vers la page de détails de l'artiste avec passage de l'ID de l'artiste
                    context.go('/b/searchdetails/${artiste.id}');
                  },
                );
              },
            ),
    );
  }
}
