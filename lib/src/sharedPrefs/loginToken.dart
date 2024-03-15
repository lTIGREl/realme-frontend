import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginToken {
  static const String _tokenKey = 'token';

  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> verifyToken() async {
    final Uri url = Uri.parse('http://192.168.1.68:4000/api/auth/verifyJWT');
    String? token = await getToken();
    final Map<String, String> body = {'token': token!};
    if (token != null) {
      try {
        var response = await http.post(
          url,
          body: body,
        );
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
