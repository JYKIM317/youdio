import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/data/repository/youtube_repository.dart';

class SearchResultViewModel extends ChangeNotifier {
  List<Youtube>? _searchResult;

  List<Youtube>? get searchResult => _searchResult;

  Future<void> searchYoutube(String search) async {
    _searchResult = await YoutubeRepository().searchYoutube(search: search);
    notifyListeners();
  }

  initialize() {
    _searchResult = null;
    notifyListeners();
  }
}

///
///
///

class SRMultiSelectViewModel extends ChangeNotifier {
  bool _multiModeState = false;
  bool get multiModeState => _multiModeState;

  List<Youtube> _selectedList = [];
  List<Youtube> get selectedList => _selectedList;

  activateState() {
    _multiModeState = true;
    notifyListeners();
  }

  selectThis(Youtube youtube) {
    if (_selectedList.contains(youtube)) {
      //선택 리스트에 해당 객체가 이미 포함되어 있는 경우
      _selectedList.remove(youtube);
      if (_selectedList.isEmpty) {
        _multiModeState = false;
      }
    } else {
      //선택 리스트에 해당 객체가 포함되어있지 않은 경우
      _selectedList.add(youtube);
    }
    notifyListeners();
  }

  initializeList() {
    _multiModeState = false;
    _selectedList = [];
    notifyListeners();
  }
}
