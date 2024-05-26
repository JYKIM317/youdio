import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShelvesScreen extends ConsumerWidget {
  const ShelvesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox();
  }
}


/*
class ShelvesScreen extends ConsumerStatefulWidget {
  const ShelvesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShelvesScreenState();
}

class _ShelvesScreenState extends ConsumerState<ShelvesScreen> {
  int idx = 0;

  String? currentVideoId;
  @override
  Widget build(BuildContext context) {
    List<Youtube> playlist = ref.watch(playlistProvider).playlist!;
    currentVideoId ??= playlist[0].id;

    print(currentVideoId);

    return Container(
      child: Column(
        children: [
          if (currentVideoId != null)
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: currentVideoId!,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
            ),
          const SizedBox(height: 20),
          IconButton(
            onPressed: () {
              setState(() {
                idx++;
                currentVideoId = playlist[idx].id;
              });
            },
            icon: Icon(Icons.add),
            color: Colors.white,
            iconSize: 48,
          ),
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.minimize_outlined),
            color: Colors.white,
            iconSize: 48,
          ),
        ],
      ),
    );
  }
} */