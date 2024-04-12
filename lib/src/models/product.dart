import 'package:real_me_fitness_center/src/configs/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  String baseUrl = '${ApiConfig().baseUrl}productos';
  //'https://realme.up.railway.app/api/clientes';
  Future<List<dynamic>> getProducts() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> products = body['body'];
        return products;
      } else {
        print('Error: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error de conexión: $e');
      return [];
    }
  }
}
