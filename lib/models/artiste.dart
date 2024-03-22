class Artiste {
  final String id;
  final String name;
  final String spotifyUrl;
  final int followers;
  final List<String> genres;
  final List<ArtistImage> images;
  final int popularity;
  String? imageUrl; // Ajout de la propriété imageUrl

  Artiste({
    required this.id,
    required this.name,
    required this.spotifyUrl,
    required this.followers,
    required this.genres,
    required this.images,
    required this.popularity,
    this.imageUrl, // Initialisation de imageUrl dans le constructeur
  });

  factory Artiste.fromJson(Map<String, dynamic> json) {
    // Extraction des images et conversion en liste d'ArtistImage
    List<ArtistImage> images = json['images'].map<ArtistImage>((imageJson) => ArtistImage.fromJson(imageJson)).toList();

    // Trouver l'URL de la plus grande image si disponible
    String? imageUrl;
    if (images.isNotEmpty) {
      imageUrl = images.first.url;
    }

    return Artiste(
      id: json['id'],
      name: json['name'],
      spotifyUrl: json['external_urls']['spotify'],
      followers: json['followers']['total'],
      genres: List<String>.from(json['genres']),
      images: images,
      popularity: json['popularity'],
      imageUrl: imageUrl, // Assigner l'URL de l'image ici
    );
  }
}

class ArtistImage {
  final int height;
  final String url;
  final int width;

  ArtistImage({
    required this.height,
    required this.url,
    required this.width,
  });

  factory ArtistImage.fromJson(Map<String, dynamic> json) {
    return ArtistImage(
      height: json['height'],
      url: json['url'],
      width: json['width'],
    );
  }
}
