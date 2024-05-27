import 'package:flutter/material.dart';
import 'package:youdio/data/model/youtube/youtube.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicViewModel extends ChangeNotifier {
  Youtube? _currentMusic;
  Youtube? get currentMusic => _currentMusic;

  bool playState = true;

  grantMusic(Youtube youtube) async {
    playState = true;
    _currentMusic = youtube;

    notifyListeners();
  }

  changePlayState() {
    if (playState) {
      playState = false;
    } else {
      playState = true;
    }
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
