import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/provider/search_provider.dart';
import 'package:youdio/provider/playlist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/presentation/snackbar.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  const SearchResultPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController selectedBarController;
  Duration eventDuration = const Duration(milliseconds: 200);
  @override
  void initState() {
    selectedBarController = AnimationController(
      vsync: this,
      duration: eventDuration,
      lowerBound: 0,
      upperBound: 100,
    )..addListener(() => setState(() {}));
    selectedBarController.value = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Youtube>? searchResult = ref.watch(searchResultProvider).searchResult;
    bool multiModeState = ref.watch(multiSelectProvider).multiModeState;
    List<Youtube> multiSelectedList =
        ref.watch(multiSelectProvider).selectedList;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            context.pop('/');
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text(
          '검색 결과',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: searchResult != null
          ? searchResult.isNotEmpty
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (multiModeState)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                selectedBarController.forward();
                                ref.read(multiSelectProvider).initializeList();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '선택해제',
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
                            itemCount: searchResult.length,
                            itemBuilder: (BuildContext ctx, int idx) {
                              bool selected =
                                  multiSelectedList.contains(searchResult[idx]);

                              return InkWell(
                                onTap: () {
                                  if (multiModeState) {
                                    ref
                                        .read(multiSelectProvider)
                                        .selectThis(searchResult[idx]);

                                    if (multiSelectedList.isEmpty) {
                                      selectedBarController.forward();
                                    }
                                  } else {
                                    if (ref.read(playlistProvider).playState) {
                                      ref
                                          .read(playlistProvider)
                                          .changePlayState();
                                    }
                                    ref
                                        .read(musicProvider)
                                        .grantMusic(searchResult[idx]);
                                    context.push('/music');
                                  }
                                },
                                onLongPress: () {
                                  //복수선택 모드 돌입
                                  if (!multiModeState) {
                                    ref
                                        .read(multiSelectProvider)
                                        .activateState();
                                    ref
                                        .read(multiSelectProvider)
                                        .selectThis(searchResult[idx]);
                                    selectedBarController.reverse();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.grey[850]!.withOpacity(0.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: searchResult[idx].id,
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: searchResult[idx]
                                                .snippet
                                                .thumbnails['medium']['url'],
                                            imageBuilder:
                                                (context, imageProvider) {
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
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              searchResult[idx].snippet.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              searchResult[idx]
                                                  .snippet
                                                  .channelTitle,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, idx) {
                              return const SizedBox(height: 10);
                            },
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    ),
                    //선택바
                    Transform.translate(
                      offset: Offset(0, selectedBarController.value),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(playlistProvider)
                              .addPlaylist(multiSelectedList);
                          selectedBarController.forward();
                          ref.read(multiSelectProvider).initializeList();
                          ScaffoldMessenger.of(context).showSnackBar(
                              YoudioSnackbar.snackBar('플레이리스트에 추가했어요!'));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topCenter,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Text(
                            '플레이리스트에 ${multiSelectedList.length}개 담기',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : emptyResult()
          : loadingResult(),
    );
  }
}

///
///
///

Widget emptyResult() {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이거 진짜에요?',
          style: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 21,
          ),
        ),
        Text(
          '검색 결과가 없어요!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 24,
          ),
        ),
      ],
    ),
  );
}

Widget loadingResult() {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '잠시만 기다려주세요',
          style: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 21,
          ),
        ),
        Text(
          '검색 결과를 불러오고 있어요',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 24,
          ),
        ),
      ],
    ),
  );
}
