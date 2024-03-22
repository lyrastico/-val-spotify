import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../models/artiste.dart';

class ArtistsSearchProvider with ChangeNotifier {
  final SpotifyService _spotifyService = SpotifyService();
  List<Artiste> _searchResults = [];

  List<Artiste> get searchResults => _searchResults;

  Future<void> searchArtists(String query) async {
    if (query.isNotEmpty) {
      _searchResults = await _spotifyService.fetchArtistsByName(query);
      notifyListeners();
    } else {
      _searchResults = [];
      notifyListeners();
    }
  }
}
