import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/provider/playlist_provider.dart';

class MusicProgressBar extends ConsumerWidget {
  const MusicProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(musicProvider).getCurrentDuration(),
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
