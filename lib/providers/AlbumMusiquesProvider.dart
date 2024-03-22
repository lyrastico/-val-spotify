import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../models/musique.dart';

class AlbumMusiquesProvider with ChangeNotifier {
  final SpotifyService _spotifyService = SpotifyService();
  List<Musique> _musiques = [];

  List<Musique> get musiques => _musiques;

  Future<void> loadMusiques(String albumId) async {
    _musiques = await _spotifyService.fetchTracksFromAlbum(albumId);
    notifyListeners();
  }
}
