import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:youdio/presentation/snackbar.dart';
import 'package:youdio/provider/search_provider.dart';

class SearchTextWidget extends ConsumerStatefulWidget {
  const SearchTextWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchTextWidgetState();
}

class _SearchTextWidgetState extends ConsumerState<SearchTextWidget> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              cursorColor: Colors.amber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              maxLines: 1,
              onSubmitted: (text) {
                String search = text.trim();
                searchController.text = '';

                if (search != '') {
                  //정상적으로 검색어가 입력 된 경우
                  ref.read(searchResultProvider).initialize();
                  ref.read(searchResultProvider).searchYoutube(search);
                  ref.read(multiSelectProvider).initializeList();
                  ref.read(searchHistoryProivder).addHistory(search);

                  context.push('/searchResult');
                } else {
                  //검색어가 입력되지 않은 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                    YoudioSnackbar.snackBar('검색어를 입력해주세요'),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.white,
            size: 21,
          )
        ],
      ),
    );
  }
}

//
//
//

class SearchHistoryWidget extends ConsumerWidget {
  const SearchHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String>? searchHistroy =
        ref.watch(searchHistoryProivder).searchHistory;
    if (searchHistroy == null) ref.read(searchHistoryProivder).fetchData();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 검색어',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: searchHistroy?.length ?? 0,
              itemBuilder: (BuildContext ctx, int idx) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            final String search = searchHistroy[idx];
                            ref.read(searchResultProvider).initialize();
                            ref
                                .read(searchResultProvider)
                                .searchYoutube(search);
                            ref.read(multiSelectProvider).initializeList();
                            ref.read(searchHistoryProivder).addHistory(search);

                            context.push('/searchResult');
                          },
                          child: Text(
                            searchHistroy![idx],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(searchHistoryProivder).removeHistory(idx);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.xmark,
                          color: Colors.grey[800],
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
