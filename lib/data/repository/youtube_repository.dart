import 'package:youdio/data/source/remote/youtube_remote.dart';
import 'package:youdio/data/model/youtube/youtube.dart';

class YoutubeRepository {
  Future<List<Youtube>> searchYoutube({required String search}) async {
    List<Youtube> searchingYoutubeList = [];

    await YoutubeRemote().request(search).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> responseItems = response.data['items'];
        for (Map<String, dynamic> item in responseItems) {
          Map<String, dynamic> youtubeJson = {
            'id': item['id']['videoId'],
            'snippet': item['snippet'],
          };

          Youtube youtube = Youtube.fromJson(youtubeJson);

          searchingYoutubeList.add(youtube);
        }
      }
    });

    return searchingYoutubeList;
  }
}
