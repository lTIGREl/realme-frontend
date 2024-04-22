class ApiConfig {
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;

  ApiConfig._internal();

  String baseUrl = 'http://192.168.0.5:4000/api/';
  //https://realme.up.railway.app/api/
}
