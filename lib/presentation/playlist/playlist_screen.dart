import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    List<Youtube>? playlist = ref.watch(playlistProvider).playlist;
    Youtube? currentPlay = ref.watch(playlistProvider).currentPlay;

    if (playlist == null) {
      ref.read(playlistProvider).fetchData();
      return const SizedBox();
    }

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      itemCount: playlist.length,
      itemBuilder: (BuildContext ctx, int idx) {
        bool playing = currentPlay == playlist[idx];

        return GestureDetector(
          onTap: () {
            if (currentPlay != playlist[idx]) {
              ref.read(playlistProvider).grantMusic(playlist[idx]);
            }
          },
          onLongPress: () {
            //TODO: 멀티셀렉트 모드로 삭제 및 서랍 보관 지원하기
          },
          child: Draggable(
            data: idx,
            //드래그 동안 보여질 위젯
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: playlist[idx].snippet.thumbnails['medium']
                            ['url'],
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist[idx].snippet.title,
                            style: TextStyle(
                              color: playing ? Colors.amber : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            playlist[idx].snippet.channelTitle,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //본체 위젯
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: playlist[idx]
                                  .snippet
                                  .thumbnails['medium']['url'],
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
                            Container(
                              color: playing
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.transparent,
                              alignment: Alignment.center,
                              child: playing
                                  ? const FaIcon(
                                      FontAwesomeIcons.play,
                                      color: Colors.amber,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlist[idx].snippet.title,
                              style: TextStyle(
                                color: playing ? Colors.amber : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              playlist[idx].snippet.channelTitle,
                              style: const TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                color: Colors.transparent,
                              );
                            },
                            onAcceptWithDetails: (detail) {
                              int initIndex = detail.data as int;
                              int changeIndex = idx - 1;
                              if (initIndex != changeIndex) {
                                ref.read(playlistProvider).playlistIndexChange(
                                    init: initIndex, change: changeIndex);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: DragTarget(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                color: Colors.transparent,
                              );
                            },
                            onAcceptWithDetails: (detail) {
                              int initIndex = detail.data as int;
                              int changeIndex = idx;
                              if (initIndex != changeIndex &&
                                  initIndex != changeIndex + 1) {
                                ref.read(playlistProvider).playlistIndexChange(
                                    init: initIndex, change: changeIndex);
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
            if (initIndex != changeIndex && initIndex != changeIndex - 1) {
              ref
                  .read(playlistProvider)
                  .playlistIndexChange(init: initIndex, change: changeIndex);
            }
          },
        );
      },
    );
  }
}
