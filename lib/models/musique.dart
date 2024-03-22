class Musique {
  final String id;
  final String titre;
  final String previewUrl;
  final int duree;
  final String artistesName; // Mis à jour pour gérer plusieurs artistes
  final String albumName; // Informations fournies séparément
  final String albumId; // Informations fournies séparément

  Musique({
    required this.id,
    required this.titre,
    required this.previewUrl,
    required this.duree,
    required this.artistesName,
    required this.albumName,
    required this.albumId,
  });

  factory Musique.fromJson(Map<String, dynamic> json, {required String albumName, required String albumId}) {
    // Concatène les noms des artistes si il y en a plusieurs
    var artistesName = (json['artists'] as List<dynamic>)
        .map((artiste) => artiste['name'] as String)
        .join(', ');

    return Musique(
      id: json['id'],
      titre: json['name'],
      previewUrl: json['preview_url'],
      duree: json['duration_ms'],
      artistesName: artistesName,
      albumName: albumName,
      albumId: albumId,
    );
  }
}
