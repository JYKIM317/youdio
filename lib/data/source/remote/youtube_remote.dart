import 'package:youdio/properties.dart';
import 'package:dio/dio.dart';

class YoutubeRemote {
  final dio = Dio();
  final String searchText = Uri.encodeFull('허각 하늘을 달리다');
  Future<Response> request(String search) async {
    final String searchText = Uri.encodeFull(search);
    var optionParams = {
      "&part=": "snippet",
      "&q=": searchText,
      "&type=": "video",
      "&maxResults=": 10,
      "&regionCode=": "KR",
    };

    String youtubeDataRequestURL =
        'https://www.googleapis.com/youtube/v3/search?&key=${APIKeys().youtubeKey}';
    for (String option in optionParams.keys) {
      youtubeDataRequestURL += option += optionParams[option].toString();
    }

    return dio.get(youtubeDataRequestURL);
  }
}
