import 'package:flutter/material.dart';
import 'package:youdio/data/repository/searchHistory_repostiry.dart';

class SearchHistoryViewModel extends ChangeNotifier {
  List<String>? _searchHistory;

  List<String>? get searchHistory => _searchHistory;

  fetchData() async {
    _searchHistory = await SearchHistoryRepository().getSearchHistory();
    notifyListeners();
  }

  addHistory(String search) {
    _searchHistory ??= [];
    if (_searchHistory!.contains(search)) {
      //히스토리 안에 검색어가 이미 있는 경우
      int idx = _searchHistory!.indexOf(search);
      _searchHistory!.removeAt(idx);
      _searchHistory!.insert(0, search);
    } else {
      //히스토리 안에 검색어가 없는 경우 (신규 검색어의 경우)
      _searchHistory!.insert(0, search);
      //검색어가 10개 초과인 경우
      if (_searchHistory!.length > 10) _searchHistory!.removeLast();
    }
    notifyListeners();
    SearchHistoryRepository().setSearchHistory(_searchHistory!);
  }

  removeHistory(int index) {
    _searchHistory!.removeAt(index);
    notifyListeners();
    SearchHistoryRepository().setSearchHistory(_searchHistory!);
  }
}
