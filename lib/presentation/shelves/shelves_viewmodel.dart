import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/data/repository/shelves_repository.dart';

class ShelvesViewModel extends ChangeNotifier {
  List<Map<String, dynamic>>? _albumList;

  List<Map<String, dynamic>>? get albumList => _albumList;

  fetchData() async {
    _albumList = await ShelvesRepository().getMyShelves();
    notifyListeners();
  }

  addAlbumList(Map<String, dynamic> album) {
    _albumList!.add(album);
    notifyListeners();
    ShelvesRepository().setMyShelves(_albumList!);
  }

  removeAlbumList(int index) {
    _albumList!.removeAt(index);
    notifyListeners();
    ShelvesRepository().setMyShelves(_albumList!);
  }

  addYoutubeInAlbum({required Youtube youtube, required int index}) {
    _albumList![index]['album'].add(youtube);
    notifyListeners();
    ShelvesRepository().setMyShelves(_albumList!);
  }

  int? selectIndex;

  setSelectIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }

  initSelectIndex() {
    if (selectIndex != null) {
      selectIndex = null;
      notifyListeners();
    }
  }
}
