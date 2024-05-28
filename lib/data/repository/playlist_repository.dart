import 'dart:convert';
import 'package:youdio/data/source/local/shared_preferences.dart';
import 'package:youdio/data/model/youtube/youtube.dart';

class PlaylistRepository {
  final String playlistKey = 'playlist';

  Future<List<Youtube>> getMyPlaylist() async {
    List<Youtube> playlist = [];
    String? playlistToString =
        await GetFromSharedPreferences().getString(playlistKey);

    if (playlistToString != null) {
      List<dynamic> jsonlist = jsonDecode(playlistToString);
      for (dynamic json in jsonlist) {
        Youtube youtube = Youtube.fromJson(json);
        playlist.add(youtube);
      }
    }

    return playlist;
  }

  Future<void> setMyPlaylist(List<Youtube> playlist) async {
    List<Map<String, dynamic>> jsonlist = [];
    for (Youtube youtube in playlist) {
      Map<String, dynamic> json = youtube.toJson();
      jsonlist.add(json);
    }

    String playlistToString = jsonEncode(jsonlist);
    await SetToSharedPreferences()
        .setString(key: playlistKey, value: playlistToString);
  }
}
