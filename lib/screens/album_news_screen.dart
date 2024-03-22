import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/albums_provider.dart'; // Assure-toi que le chemin est correct

class AlbumNewsScreen extends StatelessWidget {
  const AlbumNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // On demande au provider de charger les albums dès que l'écran est construit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumsProvider>(context, listen: false).loadAlbums();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Album News')),
      body: Consumer<AlbumsProvider>(
        builder: (context, albumsProvider, child) {
          if (albumsProvider.albums.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: albumsProvider.albums.length,
            itemBuilder: (context, index) {
              final album = albumsProvider.albums[index];
              return ListTile(
                leading: Image.network(album.imageUrl, width: 100, fit: BoxFit.cover),
                title: Text(album.name),
                onTap: () => context.go('/a/albumdetails/${album.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
