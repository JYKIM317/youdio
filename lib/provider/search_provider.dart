import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/presentation/search/searchHistory/searchHistory_viewmodel.dart';
import 'package:youdio/presentation/search/searchResult/searchReuslt_viewmodel.dart';

final searchHistoryProivder =
    ChangeNotifierProvider<SearchHistoryViewModel>((ref) {
  return SearchHistoryViewModel();
});

final searchResultProvider =
    ChangeNotifierProvider<SearchResultViewModel>((ref) {
  return SearchResultViewModel();
});

final multiSelectProvider =
    ChangeNotifierProvider<SRMultiSelectViewModel>((ref) {
  return SRMultiSelectViewModel();
});
