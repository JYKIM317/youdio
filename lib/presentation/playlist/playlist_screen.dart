import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';
import 'package:youdio/presentation/playlist/playlist_screen_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    List<Youtube>? playlist = ref.watch(playlistProvider).playlist;
    int? currentPlayIdx = ref.watch(playlistProvider).currentPlayIndex;
    bool dragPermission = ref.watch(dragProvider).dragPermission;

    if (playlist == null) {
      ref.read(playlistProvider).fetchData();
      return const SizedBox();
    }

    return Column(
      children: [
        if (dragPermission)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                ref.read(dragProvider).dismissDrag();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.listOl,
                    color: Colors.amber,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '교체 모드 해제',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            itemCount: playlist.length,
            itemBuilder: (BuildContext ctx, int idx) {
              bool playing = currentPlayIdx == idx;

              return GestureDetector(
                onTap: () {
                  if (!playing) {
                    bool isFirst =
                        ref.read(playlistProvider).player.audioSource == null;

                    if (isFirst) {
                      ref
                          .read(playlistProvider)
                          .grantMusic(youtube: playlist[idx], index: idx);
                      ref
                          .read(playlistProvider)
                          .generateConcatAudioSourceWithMyPlaylist();
                    } else {
                      ref.read(playlistProvider).changeMusic(idx);
                    }
                  }
                },
                onLongPress: () {
                  ref.read(dragProvider).grantDrag();
                },
                child: !dragPermission
                    ? YoutubeEntity(thisYoutube: playlist[idx], thisIndex: idx)
                    : Draggable(
                        data: idx,
                        //드래그 동안 보여질 위젯
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 32,
                              child: YoutubeEntity(
                                  thisYoutube: playlist[idx], thisIndex: idx)),
                        ),
                        childWhenDragging: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[850]!.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        //본체 위젯
                        child: Stack(
                          children: [
                            YoutubeEntity(
                                thisYoutube: playlist[idx], thisIndex: idx),
                            //드래그타겟
                            IgnorePointer(
                              ignoring: false,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 70,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: DragTarget(
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                        onAcceptWithDetails: (detail) {
                                          int initIndex = detail.data as int;
                                          int changeIndex = idx - 1;
                                          if (initIndex != changeIndex) {
                                            ref
                                                .read(playlistProvider)
                                                .playlistIndexChange(
                                                    init: initIndex,
                                                    change: changeIndex);
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: DragTarget(
                                        builder: (context, candidateData,
                                            rejectedData) {
                                          return Container(
                                            color: Colors.transparent,
                                          );
                                        },
                                        onAcceptWithDetails: (detail) {
                                          int initIndex = detail.data as int;
                                          int changeIndex = idx;
                                          if (initIndex != changeIndex &&
                                              initIndex != changeIndex + 1) {
                                            ref
                                                .read(playlistProvider)
                                                .playlistIndexChange(
                                                    init: initIndex,
                                                    change: changeIndex);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
            separatorBuilder: (ctx, idx) {
              return DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 10,
                  );
                },
                onAcceptWithDetails: (detail) {
                  int initIndex = detail.data as int;
                  int changeIndex = idx;
                  if (initIndex != changeIndex &&
                      initIndex != changeIndex - 1) {
                    ref.read(playlistProvider).playlistIndexChange(
                        init: initIndex, change: changeIndex);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
