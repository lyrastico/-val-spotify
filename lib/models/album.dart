class Album {
  final String id;
  final String name;
  final String imageUrl;

  Album({required this.id, required this.name, required this.imageUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['images'] != null && json['images'].isNotEmpty) {
      imageUrl = json['images'][0]['url'];
    }
    return Album(
      id: json['id'],
      name: json['name'],
      imageUrl: imageUrl,
    );
  }
}
