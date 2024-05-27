import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:youdio/data/repository/playlist_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

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

  final AudioPlayer _player = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();

  grantMusic(Youtube youtube) async {
    StreamManifest manifest =
        await _yt.videos.streamsClient.getManifest(youtube.id);
    StreamInfo info = manifest.audioOnly.withHighestBitrate();
    String audioUri = info.url.toString();

    _playState = true;
    _currentPlay = youtube;

    await _player.setUrl(audioUri);
    _player.play();

    notifyListeners();
  }

  changePlayState() {
    if (_playState) {
      _player.pause();
      _playState = false;
    } else {
      if (currentPlay != null) {
        //현재 플레이가 있고, 끝까지 재생했다면
        if (_player.position >= _player.duration!) {
          _player.seek(Duration.zero);
          _player.play();
          _playState = true;
        } else {
          //현재 플레이가 있고, 재생중이었다면
          _player.play();
          _playState = true;
        }
      } else if (playlist != null && playlist!.isNotEmpty) {
        //현재 플레이는 없지만 플레이리스트가 있을경우
        grantMusic(playlist!.first);
      }
    }

    notifyListeners();
  }

  Timer? throttleTimer;

  Stream<int> getCurrentDuration() async* {
    int position = _player.position.inSeconds;
    int duration = _player.duration?.inSeconds ?? 0;
    notifyListeners();
    int progress = (position / duration * 100).toInt();

    if (position >= duration) {
      _player.pause();
      _playState = false;
      if (throttleTimer == null || !throttleTimer!.isActive) {
        throttleTimer = Timer(const Duration(seconds: 60), () {});
        forwardPlay();
      }
    }

    yield progress;
  }

  bool forwardPlay() {
    bool result = false;
    //다음 곡 있으면 자동 재생
    if (playlist != null && currentPlay != null) {
      int currentIdx = playlist!.indexOf(currentPlay!);
      if (currentIdx < playlist!.length - 1) {
        grantMusic(playlist![currentIdx + 1]);
        result = true;
      }
    }

    return result;
  }

  bool backwardPlay() {
    bool result = false;
    //이전 곡 있으면 자동 재생
    if (playlist != null && currentPlay != null) {
      int currentIdx = playlist!.indexOf(currentPlay!);
      if (currentIdx != 0) {
        grantMusic(playlist![currentIdx - 1]);
        result = true;
      }
    }

    return result;
  }
}
