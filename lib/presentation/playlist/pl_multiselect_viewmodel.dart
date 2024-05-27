import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';

class PLMultiSelectViewModel extends ChangeNotifier {
  bool _multiModeState = false;
  bool get multiModeState => _multiModeState;

  List<Youtube> _selectedList = [];
  List<Youtube> get selectedList => _selectedList;
  List<int> _selectedIndex = [];
  List<int> get selectedIndex => _selectedIndex;

  activateState() {
    _multiModeState = true;
    notifyListeners();
  }

  selectThis({required Youtube youtube, required int index}) {
    if (_selectedList.contains(youtube)) {
      //선택 리스트에 해당 객체가 이미 포함되어 있는 경우
      _selectedList.remove(youtube);
      if (_selectedList.isEmpty) {
        _multiModeState = false;
      }
      notifyListeners();
    } else {
      //선택 리스트에 해당 객체가 포함되어있지 않은 경우
      _selectedList.add(youtube);
      notifyListeners();
    }
  }

  initializeList() {
    _multiModeState = false;
    _selectedList = [];
    notifyListeners();
  }
}
