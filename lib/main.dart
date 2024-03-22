import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/providers/AlbumMusiquesProvider.dart';
import 'package:projet_spotify_gorouter/providers/ArtisteDetailsProvider.dart';
import 'package:projet_spotify_gorouter/providers/ArtistsSearchProvider.dart';
import 'package:projet_spotify_gorouter/services/spotify_service.dart';
import 'package:provider/provider.dart';
import 'package:projet_spotify_gorouter/router/router_config.dart';
import 'providers/albums_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider est utilisé ici pour permettre l'ajout de plusieurs providers si nécessaire.
    return MultiProvider(
      providers: [
        Provider<SpotifyService>(create: (_) => SpotifyService()),
        ChangeNotifierProvider(create: (context) => AlbumsProvider()),
        ChangeNotifierProvider(create: (context) => AlbumMusiquesProvider()),
        ChangeNotifierProvider(create: (context) => ArtistsSearchProvider()),
        ChangeNotifierProvider(create: (context) => ArtisteDetailsProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
        ),
      ),
    );
  }
}
