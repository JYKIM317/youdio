import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CurrentMusicStateWidget extends ConsumerStatefulWidget {
  const CurrentMusicStateWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentMusicStateWidgetState();
}

class _CurrentMusicStateWidgetState
    extends ConsumerState<CurrentMusicStateWidget> {
  @override
  Widget build(BuildContext context) {
    bool playState = ref.watch(playlistProvider).playState;
    Youtube? currentPlay = ref.watch(playlistProvider).currentPlay;
    YoutubePlayerController? youtubePlayerController =
        ref.watch(playlistProvider).youtubePlayerController;

    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: const Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 0.1,
          ),
        ),
      ),
      child: Column(
        children: [
          StreamBuilder(
            stream: ref.read(playlistProvider).getCurrentDuration(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              int? progress = snapshot.data;

              if (progress == null) {
                return Container(height: 2, color: Colors.grey[850]);
              }

              return Row(
                children: [
                  Expanded(
                    flex: progress,
                    child: Container(
                      height: 2,
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 100 - progress,
                    child: Container(
                      height: 2,
                      color: Colors.grey[850],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                //musicState
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPlay?.snippet.title ?? '재생중인 노래가 없어요..',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentPlay?.snippet.channelTitle ?? '',
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                //본체
                SizedBox(
                  width: 10,
                  height: 0,
                  child: Transform.translate(
                    offset: const Offset(0, 100),
                    child: youtubePlayerController != null
                        ? YoutubePlayer(
                            onEnded: (_) {
                              ref.read(playlistProvider).changePlayState();
                              //TODO: 다음곡 있으면 넘어가는 로직
                            },
                            controller: youtubePlayerController,
                          )
                        : null,
                  ),
                ),
                //playState
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        //TODO:
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.backwardStep,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ref.read(playlistProvider).changePlayState();
                      },
                      icon: FaIcon(
                        playState
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //TODO:
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.forwardStep,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
