import 'dart:convert';
import 'package:youdio/data/source/local/shared_preferences.dart';
import 'package:youdio/data/model/youtube/youtube.dart';

class ShelvesRepository {
  final String shelvesKey = 'shelves';

  Future<List<Map<String, dynamic>>> getMyShelves() async {
    List<Map<String, dynamic>> albumlist = [];

    List<String>? albumStringList =
        await GetFromSharedPreferences().getStringList(shelvesKey);

    if (albumStringList != null) {
      for (String albumString in albumStringList) {
        List<Youtube> albumEntityList = [];

        Map<String, dynamic> json = jsonDecode(albumString);
        List<dynamic> youtubeList = json['album'];
        albumEntityList =
            youtubeList.map((youtube) => Youtube.fromJson(youtube)).toList();
        Map<String, dynamic> album = {
          'title': json['title'],
          'album': albumEntityList,
        };
        albumlist.add(album);
      }
    }

    return albumlist;
  }

  Future<void> setMyShelves(List<Map<String, dynamic>> shelves) async {
    List<String> albumStringList = [];

    for (Map<String, dynamic> album in shelves) {
      List<Map<String, dynamic>> albumEntityList = [];
      List<Youtube> youtubeList = album['album'];
      albumEntityList = youtubeList.map((entity) => entity.toJson()).toList();
      Map<String, dynamic> json = {
        'title': album['title'],
        'album': albumEntityList
      };
      String albumString = jsonEncode(json);
      albumStringList.add(albumString);
    }

    await SetToSharedPreferences()
        .setStringList(key: shelvesKey, value: albumStringList);
  }
}
