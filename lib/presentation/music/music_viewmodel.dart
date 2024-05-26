import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicViewModel extends ChangeNotifier {
  Youtube? _currentMusic;
  Youtube? get currentMusic => _currentMusic;

  late YoutubePlayerController _youtubePlayerController;
  YoutubePlayerController get youtubePlayerController =>
      _youtubePlayerController;

  bool playState = true;

  grantMusic(Youtube youtube) {
    playState = true;
    _currentMusic = youtube;

    //
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: currentMusic!.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    //
    notifyListeners();
  }

  changePlayState() {
    if (playState) {
      youtubePlayerController.pause();
      playState = false;
    } else {
      youtubePlayerController.play();
      playState = true;
    }
    notifyListeners();
  }

  initController() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: currentMusic!.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  Stream<Map<String, int>> getCurrentDuration() async* {
    Map<String, int> currentDuration = {
      'position': youtubePlayerController.value.position.inSeconds,
      'duration': youtubePlayerController.value.metaData.duration.inSeconds,
    };
    yield currentDuration;
    notifyListeners();
  }
}

///
///
///

class ImageColorViewModel extends ChangeNotifier {
  Color? _prominentColor;

  Color? get prominentColor => _prominentColor;

  Future<void> getProminentColor(String imageUrl) async {
    PaletteGenerator? paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      Image.network(imageUrl).image,
    );
    _prominentColor = paletteGenerator.colors.first;
    notifyListeners();
  }
}
