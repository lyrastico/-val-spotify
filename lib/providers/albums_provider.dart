// /lib/providers/albums_provider.dart
import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../models/album.dart';

class AlbumsProvider with ChangeNotifier {
  final SpotifyService _spotifyService = SpotifyService();
  List<Album> _albums = [];

  List<Album> get albums => _albums;

  Future<void> loadAlbums() async {
    try {
      _albums = await _spotifyService.fetchNewReleases();
      notifyListeners();
    } catch (error) {
      print('Error fetching albums: $error');
      _albums = [];
      notifyListeners();
    }
  }
}
