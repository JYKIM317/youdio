import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/presentation/snackbar.dart';
import 'package:youdio/provider/mainpage_provider.dart';
import 'package:youdio/provider/playlist_provider.dart';
import 'package:youdio/provider/shelves_provider.dart';

class AlbumWidget extends ConsumerWidget {
  final List<Youtube> album;
  const AlbumWidget({super.key, required this.album});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 180,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: List.generate(3, (index) {
          int showIndex = 2 - index;
          return Transform.rotate(
            angle: (10 * (showIndex)) * math.pi / 180,
            child: Transform.translate(
              offset: Offset((showIndex) * 20, (showIndex) * 2),
              child: SizedBox(
                width: 150 - ((showIndex) * 10),
                height: 150 - ((showIndex) * 10),
                child: CachedNetworkImage(
                  imageUrl: album[showIndex].snippet.thumbnails['medium']
                      ['url'],
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
          );
        }),
      ),
    );
  }
}

class ShelvesAlert extends ConsumerStatefulWidget {
  const ShelvesAlert({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShelvesAlertState();
}

class _ShelvesAlertState extends ConsumerState<ShelvesAlert> {
  TextEditingController titleController = TextEditingController();
  String title = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
              '현재 플레이리스트를\n서랍에 보관할까요?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '플레이리스트 이름 :',
                  style: TextStyle(color: Colors.grey),
                ),
                Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      focusColor: Colors.grey,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    cursorColor: Colors.grey,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (text) {
                      title = text;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '취소할게요',
                    style: TextStyle(
                      color: Colors.amber.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    List<Youtube> myPlaylist =
                        ref.read(playlistProvider).playlist ?? [];
                    if (myPlaylist.length >= 3) {
                      if (title.trim() != '') {
                        Map<String, dynamic> album = {
                          'title': title,
                          'album': myPlaylist,
                        };
                        ref.read(shelvesProvider).addAlbumList(album);
                        ScaffoldMessenger.of(context).showSnackBar(
                          YoudioSnackbar.snackBar('보관을 완료했어요'),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          YoudioSnackbar.snackBar('플레이리스트 이름을 입력해주세요'),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        YoudioSnackbar.snackBar('플레이리스트에 3곡 이상 있어야 보관할 수 있어요'),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    '보관할게요',
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

class ReplaceToPlaylistAlert extends ConsumerStatefulWidget {
  final List<Youtube> thisAlbum;
  const ReplaceToPlaylistAlert({super.key, required this.thisAlbum});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReplaceToPlaylistAlertState();
}

class _ReplaceToPlaylistAlertState
    extends ConsumerState<ReplaceToPlaylistAlert> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: EdgeInsets.symmetric(
            horizontal: 30, vertical: MediaQuery.of(context).size.height / 3.5),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                  text: '선택하신 앨범을\n플레이리스트로 교체할까요?\n\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                  children: [
                    TextSpan(
                      text: '주의하세요! 현재 플레이리스트는 초기화됩니다.',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                      ),
                    )
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '취소할게요',
                    style: TextStyle(
                      color: Colors.amber.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(playlistProvider).initializePlaylist();
                    ref.read(playlistProvider).addPlaylist(widget.thisAlbum);
                    Navigator.pop(context);
                    ref.read(indexProvider.notifier).selectIndex(0);
                  },
                  child: const Text(
                    '교체할게요',
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
