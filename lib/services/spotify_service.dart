// /lib/services/spotify_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/album.dart';
import '../models/musique.dart';
import '../models/artiste.dart';

class SpotifyService {
  final String _accessToken =
      'BQDuZ7p7htiFvB4PZ-boItBfJB3fcrc-ttAtGxhgMDc12qM4QPTdeNlD5m1eoS9zRoNHziRgL5K_e8_4tkbQHbBD-r4nowxcn5zQn4erP6h0QXGiPjw';

  Future<List<Musique>> fetchTracksFromAlbum(String albumId) async {
    final url = Uri.parse('https://api.spotify.com/v1/albums/$albumId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final albumName = data['name']; // Nom de l'album
      final albumId = data['id']; // ID de l'album

      // Assurez-vous que la réponse contient bien les pistes
      if (data['tracks'] != null && data['tracks']['items'] != null) {
        List<dynamic> tracksJson = data['tracks']['items'];
        // Créez des objets Musique avec les informations complètes, y compris le nom et l'ID de l'album
        List<Musique> tracks = tracksJson
            .map((json) => Musique.fromJson(
                  json,
                  albumName:
                      albumName, // Passez le nom de l'album récupéré à Musique.fromJson
                  albumId:
                      albumId, // Passez l'ID de l'album récupéré à Musique.fromJson
                ))
            .toList();
        return tracks;
      } else {
        throw Exception('Tracks are null or missing');
      }
    } else {
      throw Exception(
          'Failed to load album tracks with status code: ${response.statusCode}');
    }
  }

  Future<List<Album>> fetchNewReleases() async {
    // Inclure le token d'accès directement dans l'URL n'est pas la pratique recommandée.
    // C'est juste pour correspondre à l'exemple donné. Normalement, le token devrait être ajouté dans les headers de la requête.
    final url = Uri.parse(
        'https://api.spotify.com/v1/browse/new-releases?access_token=$_accessToken');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> albumsJson = jsonDecode(response.body)['albums']['items'];
      List<Album> albums =
          albumsJson.map((json) => Album.fromJson(json)).toList();
      return albums;
    } else {
      throw Exception('Failed to load new releases');
    }
  }

  Future<List<Artiste>> fetchArtistsByName(String query) async {
    final url = Uri.parse(
        'https://api.spotify.com/v1/search?q=$query&type=artist&limit=10');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['artists'] != null && data['artists']['items'] != null) {
        List<dynamic> artistsJson = data['artists']['items'];
        List<Artiste> artists =
            artistsJson.map((json) => Artiste.fromJson(json)).toList();
        return artists;
      } else {
        throw Exception('Artists are null or missing');
      }
    } else {
      throw Exception(
          'Failed to search artists with status code: ${response.statusCode}');
    }
  }

  Future<Artiste> fetchArtistDetailsById(String artistId) async {
  final url = Uri.parse('https://api.spotify.com/v1/artists/$artistId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $_accessToken',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Artiste.fromJson(data);
  } else {
    throw Exception('Failed to load artist details with status code: ${response.statusCode}');
  }
}
}
