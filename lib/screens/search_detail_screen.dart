import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_spotify_gorouter/providers/ArtisteDetailsProvider.dart';

class SearchDetailsScreen extends StatelessWidget {
  final String artistId;

  const SearchDetailsScreen({Key? key, required this.artistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArtisteDetailsProvider>(context, listen: false)
          .loadArtisteDetails(artistId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de l\'Artiste')),
      body: Consumer<ArtisteDetailsProvider>(
        builder: (context, artisteDetailsProvider, child) {
          final artiste = artisteDetailsProvider.artisteDetails;
          if (artiste == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (artiste.imageUrl != null)
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(artiste.imageUrl!),
                  ),
                const SizedBox(height: 20),
                Text(
                  artiste.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  "Followers: ${artiste.followers}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "Genres: ${artiste.genres.join(", ")}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "Popularité: ${artiste.popularity}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Ici, tu pourrais ajouter une liste d'albums si ton modèle Artiste les inclut
              ],
            ),
          );
        },
      ),
    );
  }
}
