import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/presentation/snackbar.dart';
import 'package:youdio/provider/shelves_provider.dart';

class MusicProgressBar extends ConsumerWidget {
  final Stream<Map<String, int>> stream;
  const MusicProgressBar({super.key, required this.stream});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Map<String, int>? time = snapshot.data;
        if (time == null || (time['position'] == 0 && time['duration'] == 0)) {
          return progressLoadingWidget();
        }

        int progress = (time['position']! / time['duration']! * 100).toInt();
        int d_minute = time['duration']! ~/ 60;
        int d_second = (time['duration']! % 60).toInt();
        int p_minute = time['position']! ~/ 60;
        int p_second = (time['position']! % 60).toInt();

        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: progress,
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.width - 32),
                      height: 2,
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 100 - progress,
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.width - 32),
                      height: 2,
                      color: Colors.grey[850],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$p_minute:${p_second.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$d_minute:${d_second.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

///
///
///

Widget progressLoadingWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: double.infinity,
        height: 2,
        color: Colors.grey[850],
      ),
      const SizedBox(height: 8),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '0:00',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '0:00',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

class AddToAlbumAlert extends ConsumerWidget {
  final Youtube selectYoutube;
  const AddToAlbumAlert({super.key, required this.selectYoutube});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>>? shelves = ref.watch(shelvesProvider).albumList;
    shelves ?? ref.read(shelvesProvider).fetchData();

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: EdgeInsets.symmetric(
            horizontal: 30, vertical: MediaQuery.of(context).size.height / 4),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '추가할 앨범을 선택해주세요',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: shelves != null
                  ? ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: shelves.length,
                      itemBuilder: (BuildContext ctx, int idx) {
                        return InkWell(
                          onTap: () {
                            ref.read(shelvesProvider).addYoutubeInAlbum(
                                youtube: selectYoutube, index: idx);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              YoudioSnackbar.snackBar('선택한 앨범에 추가했어요!'),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.folder,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    shelves[idx]['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, idx) {
                        return const SizedBox(height: 8);
                      },
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '취소할게요',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
