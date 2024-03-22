import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/AlbumMusiquesProvider.dart';
import '../models/musique.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  static final AudioPlayer player = AudioPlayer();
  int? playingTrackIndex;
  bool isPlaying = false;
  Musique? currentPlayingTrack;
  double currentPosition = 0.0;
  double totalDuration = 0.0;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration.inMilliseconds.toDouble();
      });
    });
    player.onAudioPositionChanged.listen((position) {
      setState(() {
        currentPosition = position.inMilliseconds.toDouble();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumMusiquesProvider>(context, listen: false)
          .loadMusiques(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details')),
      body: Consumer<AlbumMusiquesProvider>(
        builder: (context, albumMusiquesProvider, child) {
          if (albumMusiquesProvider.musiques.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: albumMusiquesProvider.musiques.length,
            itemBuilder: (context, index) {
              final Musique musique = albumMusiquesProvider.musiques[index];
              final isCurrentPlaying = index == playingTrackIndex;

              return ListTile(
                title: Text(musique.titre),
                subtitle: Text('Durée: ${musique.duree}ms'),
                trailing: IconButton(
                  icon: Icon(isCurrentPlaying && isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  onPressed: () async {
                    if (isCurrentPlaying && isPlaying) {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await player.setUrl(musique.previewUrl);
                      player.play(musique.previewUrl);
                      setState(() {
                        playingTrackIndex = index;
                        isPlaying = true;
                        currentPlayingTrack = musique;
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: currentPlayingTrack != null
          ? BottomAppBar(
              color: Colors.black,
              child: Container(
                height: 90.0,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentPlayingTrack!.titre,
                                  style: const TextStyle(color: Colors.white)),
                              Text(currentPlayingTrack!.artistesName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          12)), // Utilise plutôt une propriété de currentPlayingTrack si disponible
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white),
                          onPressed: () {
                            if (isPlaying) {
                              player.pause();
                              setState(() => isPlaying = false);
                            } else {
                              player.play(currentPlayingTrack!
                                  .previewUrl); // Correction ici
                              setState(() => isPlaying = true);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    player
        .dispose(); // Libère les ressources du lecteur audio lors de la suppression de l'écran
    super.dispose();
  }
}
