import 'package:shared_preferences/shared_preferences.dart';

class GetFromSharedPreferences {
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    return data;
  }

  Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(key);

    return data;
  }
}

class SetToSharedPreferences {
  Future<void> setString({
    required String key,
    required String value,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> setStringList({
    required String key,
    required List<String> value,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
}
