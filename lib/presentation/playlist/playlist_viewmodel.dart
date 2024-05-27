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

  int? _currentPlayIndex;
  int? get currentPlayIndex => _currentPlayIndex;

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

  removePlaylist(int idx) {
    _playlist!.removeAt(idx);
    if (currentPlayIndex == idx) {
      if (playlist!.length - 1 > idx) {
        changeMusic(idx);
        _player.stop();
      } else if (playlist!.length == 1) {
        _currentPlay = null;
        _currentPlayIndex = null;
        _playState = false;
        _player.stop();
      } else {
        backwardPlay();
      }
    }
    notifyListeners();
    generateConcatAudioSourceWithMyPlaylist();
    PlaylistRepository().setMyPlaylist(_playlist!);
  }

  initializePlaylist() {
    _playlist = [];
    PlaylistRepository().setMyPlaylist(_playlist!);
    notifyListeners();
  }

  playlistIndexChange({required int init, required int change}) {
    bool current = init == currentPlayIndex;
    if (init > change) {
      Youtube initData = _playlist!.removeAt(init);
      _playlist!.insert(change + 1, initData);
      if (current) {
        _currentPlayIndex = change + 1;
      }
    } else {
      Youtube initData = _playlist!.removeAt(init);
      _playlist!.insert(change, initData);
      if (current) {
        _currentPlayIndex = change;
      }
    }
    notifyListeners();
    PlaylistRepository().setMyPlaylist(_playlist!);
  }

  ///
  ///
  ///

  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;
  final YoutubeExplode _yt = YoutubeExplode();

  generateConcatAudioSourceWithMyPlaylist() async {
    List<String> audioUrls = [];
    for (Youtube play in playlist!) {
      StreamManifest manifest =
          await _yt.videos.streamsClient.getManifest(play.id);
      StreamInfo info = manifest.audioOnly.withHighestBitrate();
      String audioUri = info.url.toString();
      audioUrls.add(audioUri);
    }
    final listsource = ConcatenatingAudioSource(
      children: List.generate(
        audioUrls.length,
        (index) => AudioSource.uri(
          Uri.parse(
            audioUrls[index],
          ),
        ),
      ),
    );
    await _player.setAudioSource(listsource,
        initialIndex: currentPlayIndex, initialPosition: _player.position);
  }

  grantMusic({required Youtube youtube, required int index}) async {
    StreamManifest manifest =
        await _yt.videos.streamsClient.getManifest(youtube.id);
    StreamInfo info = manifest.audioOnly.withHighestBitrate();
    String audioUri = info.url.toString();

    _playState = true;
    _currentPlay = youtube;
    _currentPlayIndex = index;

    await _player.setUrl(audioUri);
    _player.play();

    notifyListeners();
  }

  changeMusic(int index) async {
    _playState = true;
    _currentPlay = playlist![index];
    _currentPlayIndex = index;

    notifyListeners();
    await _player.seek(Duration.zero, index: index);
    _player.play();
  }

  changeMusicStateComebackForeground(int index) {
    _currentPlayIndex = index;
    _currentPlay = playlist![index];
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
        throttleTimer = Timer(const Duration(seconds: 10), () {});
        forwardPlay();
      }
    }

    yield progress;
  }

  bool forwardPlay() {
    bool result = false;
    //다음 곡 있으면 자동 재생
    if (playlist != null && currentPlay != null) {
      if (currentPlayIndex! < playlist!.length - 1) {
        changeMusic(currentPlayIndex! + 1);

        result = true;
        notifyListeners();
      }
    }

    return result;
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
        grantMusic(youtube: playlist!.first, index: 0);
        generateConcatAudioSourceWithMyPlaylist();
      }
    }

    notifyListeners();
  }

  bool backwardPlay() {
    bool result = false;
    //이전 곡 있으면 자동 재생
    if (playlist != null && currentPlay != null) {
      if (currentPlayIndex != 0) {
        changeMusic(currentPlayIndex! - 1);

        result = true;
        notifyListeners();
      }
    }

    return result;
  }
}

class DragViewModel extends ChangeNotifier {
  bool _dragPermission = false;
  bool get dragPermission => _dragPermission;

  grantDrag() {
    _dragPermission = true;
    notifyListeners();
  }

  dismissDrag() {
    _dragPermission = false;
    notifyListeners();
  }
}
