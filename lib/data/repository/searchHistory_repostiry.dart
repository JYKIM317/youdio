import 'package:youdio/data/source/local/shared_preferences.dart';

class SearchHistoryRepository {
  final String searchHistoryKey = 'searchHistory';

  Future<List<String>> getSearchHistory() async {
    List<String> searchHistory = [];

    await GetFromSharedPreferences()
        .getStringList(searchHistoryKey)
        .then((result) {
      if (result != null && result.isNotEmpty) {
        searchHistory.addAll(result);
      }
    });

    return searchHistory;
  }

  Future<void> setSearchHistory(List<String> searchHistory) async {
    await SetToSharedPreferences()
        .setStringList(key: searchHistoryKey, value: searchHistory);
  }
}
