import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youdio/presentation/shelves/shelves_screen_widget.dart';
import 'package:youdio/provider/shelves_provider.dart';

class ShelvesScreen extends ConsumerWidget {
  const ShelvesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>>? albumList =
        ref.watch(shelvesProvider).albumList;

    int? selectIndex = ref.watch(shelvesProvider).selectIndex;

    if (albumList == null) {
      ref.read(shelvesProvider).fetchData();
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        ref.read(shelvesProvider).initSelectIndex();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                runSpacing: 20,
                children: List.generate(
                  albumList.length,
                  (int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ReplaceToPlaylistAlert(
                                      thisAlbum: albumList[index]['album']);
                                },
                              );
                            },
                            onLongPress: () {
                              ref.read(shelvesProvider).setSelectIndex(index);
                            },
                            child:
                                AlbumWidget(album: albumList[index]['album']),
                          ),
                          if (selectIndex == index)
                            Transform.translate(
                              offset: const Offset(-10, -15),
                              child: IconButton(
                                onPressed: () {
                                  ref.read(shelvesProvider).initSelectIndex();
                                  ref
                                      .read(shelvesProvider)
                                      .removeAlbumList(index);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.circleMinus,
                                  color: Colors.white,
                                  size: 28,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 160,
                        child: Text(
                          albumList[index]['title'],
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const ShelvesAlert();
                    },
                  );
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.grey[850],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
