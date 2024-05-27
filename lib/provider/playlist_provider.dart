import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youdio/presentation/playlist/playlist_viewmodel.dart';
import 'package:youdio/presentation/shelves/shelves_viewmodel.dart';
import 'package:youdio/presentation/music/music_viewmodel.dart';

final playlistProvider = ChangeNotifierProvider<PlaylistViewModel>((ref) {
  return PlaylistViewModel();
});

final dragProvider = ChangeNotifierProvider<DragViewModel>((ref) {
  return DragViewModel();
});

final shelvesProvider = ChangeNotifierProvider<ShelvesViewModel>((ref) {
  return ShelvesViewModel();
});

final musicProvider = ChangeNotifierProvider<MusicViewModel>((ref) {
  return MusicViewModel();
});

final imageColorProvider = ChangeNotifierProvider<ImageColorViewModel>((ref) {
  return ImageColorViewModel();
});
