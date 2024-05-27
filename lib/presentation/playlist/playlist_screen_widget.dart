import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/playlist_provider.dart';

class YoutubeEntity extends ConsumerStatefulWidget {
  final Youtube thisYoutube;
  final int thisIndex;
  const YoutubeEntity({
    super.key,
    required this.thisYoutube,
    required this.thisIndex,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YoutubeEntityState();
}

class _YoutubeEntityState extends ConsumerState<YoutubeEntity> {
  double startValue = 0;
  double moveValue = 0;

  @override
  Widget build(BuildContext context) {
    int? currentPlayIdx = ref.watch(playlistProvider).currentPlayIndex;
    bool playing = currentPlayIdx == widget.thisIndex;

    return GestureDetector(
      onHorizontalDragStart: (start) {
        setState(() {
          startValue = start.globalPosition.dx;
        });
      },
      onHorizontalDragUpdate: (move) {
        double temp = startValue - move.globalPosition.dx;
        setState(() {
          if (temp >= 60) {
            moveValue = 60;
          } else if (temp < 60 && temp > 0) {
            moveValue = temp;
          } else {
            moveValue = 0;
          }
        });
      },
      onHorizontalDragEnd: (end) {
        if (moveValue < 60) {
          setState(() {
            moveValue = 0;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 70,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                ref.read(playlistProvider).removePlaylist(widget.thisIndex);
                setState(() {
                  moveValue = 0;
                });
              },
              icon: const FaIcon(
                FontAwesomeIcons.trashCan,
                color: Colors.white,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-moveValue, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
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
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget
                              .thisYoutube.snippet.thumbnails['medium']['url'],
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
                          widget.thisYoutube.snippet.title,
                          style: TextStyle(
                            color: playing ? Colors.amber : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.thisYoutube.snippet.channelTitle,
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
        ],
      ),
    );
  }
}
