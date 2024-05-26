import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:youdio/presentation/music/music_page_widget.dart';
import 'package:youdio/presentation/snackbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';

class MusicPage extends ConsumerStatefulWidget {
  const MusicPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MusicPageState();
}

class _MusicPageState extends ConsumerState<MusicPage> {
  @override
  void initState() {
    ref.read(musicProvider).initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double thumbnailSize = MediaQuery.of(context).size.width - 32;
    Youtube currentYoutube = ref.watch(musicProvider).currentMusic!;

    ref
        .read(imageColorProvider)
        .getProminentColor(currentYoutube.snippet.thumbnails['medium']['url']);
    Color? prominentColor = ref.watch(imageColorProvider).prominentColor;

    YoutubePlayerController youtubePlayerController =
        ref.watch(musicProvider).youtubePlayerController;
    bool playState = ref.watch(musicProvider).playState;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: prominentColor?.withOpacity(0.4) ?? Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentYoutube.snippet.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                currentYoutube.snippet.channelTitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 16,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                context.pop('/');
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronDown,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 83),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              prominentColor?.withOpacity(0.4) ?? Colors.transparent,
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: currentYoutube.id,
              child: Container(
                width: thumbnailSize,
                height: thumbnailSize,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: prominentColor ?? Colors.transparent,
                    width: 0.2,
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: currentYoutube.snippet.thumbnails['medium']['url'],
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(flex: 2, child: MusicProgressBar()),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: () {
                        //현재 플리에 저장
                        ref
                            .read(playlistProvider)
                            .addPlaylist([currentYoutube]);
                        ScaffoldMessenger.of(context).showSnackBar(
                            YoudioSnackbar.snackBar('플레이리스트에 추가했어요!'));
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.layerGroup,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: () {
                        ref.read(musicProvider).changePlayState();
                      },
                      icon: FaIcon(
                        playState
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: () {
                        String todo = 'todo';
                        //TODO: 서랍 플리에 저장

                        ScaffoldMessenger.of(context).showSnackBar(
                            YoudioSnackbar.snackBar('선택한 서랍에 추가했어요!'));
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.folderOpen,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0,
              height: 0,
              child: Transform.translate(
                offset: const Offset(0, 100),
                child: YoutubePlayer(
                  onEnded: (_) {
                    ref.read(musicProvider).changePlayState();
                  },
                  controller: youtubePlayerController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
