// Dans /lib/providers/artiste_details_provider.dart
import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../models/artiste.dart';

class ArtisteDetailsProvider with ChangeNotifier {
  final SpotifyService _spotifyService = SpotifyService();
  Artiste? _artisteDetails;

  Artiste? get artisteDetails => _artisteDetails;

  Future<void> loadArtisteDetails(String artistId) async {
    _artisteDetails = await _spotifyService.fetchArtistDetailsById(artistId);
    notifyListeners();
  }
}
