import 'package:shared_preferences/shared_preferences.dart';

class SplashSharedPref {
  static const _keyToken = 'token';

  static Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, value);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  static Future<void> printToken() async {
    final token = await getToken();
    print('Stored Token: $token');
  }
}
