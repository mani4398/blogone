import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String tokenKey = "tokenKey";

  //save data
  Future<bool> saveToken(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(tokenKey, getToken);
  }

  // get data
  Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getString(tokenKey);
    } on Exception catch (e) {
      print(e);
    }
  }
}
