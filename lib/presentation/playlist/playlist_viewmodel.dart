import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/data/repository/playlist_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistViewModel extends ChangeNotifier {
  List<Youtube>? _playlist;
  List<Youtube>? get playlist => _playlist;

  Youtube? _currentPlay;
  Youtube? get currentPlay => _currentPlay;

  bool _playState = false;
  bool get playState => _playState;

  fetchData() async {
    _playlist = await PlaylistRepository().getMyPlaylist();
    notifyListeners();
  }

  addPlaylist(List<Youtube> list) {
    _playlist ??= [];
    _playlist!.addAll(list);
    PlaylistRepository().setMyPlaylist(_playlist!);
    notifyListeners();
  }

  removePlaylist(List<int> indexlist) {
    for (int idx in indexlist) {
      _playlist!.removeAt(idx);
    }
    PlaylistRepository().setMyPlaylist(_playlist!);
    notifyListeners();
  }

  initializePlaylist() {
    _playlist = [];
    PlaylistRepository().setMyPlaylist(_playlist!);
    notifyListeners();
  }

  playlistIndexChange({required int init, required int change}) {
    if (init > change) {
      Youtube initData = _playlist!.removeAt(init);
      _playlist!.insert(change + 1, initData);
    } else {
      Youtube initData = _playlist!.removeAt(init);
      _playlist!.insert(change, initData);
    }
    notifyListeners();
    PlaylistRepository().setMyPlaylist(_playlist!);
  }

  ///
  ///
  ///

  YoutubePlayerController? _youtubePlayerController;
  YoutubePlayerController? get youtubePlayerController =>
      _youtubePlayerController;

  grantMusic(Youtube youtube) {
    _playState = true;
    _currentPlay = youtube;

    initController();

    notifyListeners();
  }

  changePlayState() {
    if (_playState) {
      _youtubePlayerController!.pause();
      _playState = false;
    } else {
      if (currentPlay != null) {
        //현재 플레이가 있었다면
        _youtubePlayerController!.play();
        _playState = true;
      } else if (playlist != null && playlist!.isNotEmpty) {
        //현재 플레이는 없지만 플레이리스트가 있을경우
        grantMusic(playlist!.first);
      }
    }
    notifyListeners();
  }

  initController() {
    _youtubePlayerController = null;
    notifyListeners();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: currentPlay!.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  Stream<int> getCurrentDuration() async* {
    int position = youtubePlayerController!.value.position.inSeconds;
    int duration = youtubePlayerController!.value.metaData.duration.inSeconds;
    notifyListeners();
    int progress = (position / duration * 100).toInt();

    yield progress;
  }
}
