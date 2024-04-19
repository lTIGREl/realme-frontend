import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:real_me_fitness_center/src/configs/api.dart';
import 'package:real_me_fitness_center/src/models/product.dart';

class Sale {
  final String _baseUrl = '${ApiConfig().baseUrl}compras';
  Future<List<dynamic>> getSales() async {
    final url = Uri.parse(_baseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> clients = body['body'];
        return clients;
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

  //'https://realme.up.railway.app/api/clientes';
  Future<bool> postSale(String quantity, String product, String mode,
      String client, String debt) async {
    final url = Uri.parse(_baseUrl);
    final Map<String, dynamic> body = {
      'id': '0',
      'quantity': quantity,
      'product_id': product,
      'p_date': DateFormat('yyyy-MM-dd', 'es_MX').format(DateTime.now()),
      'method': mode,
      'client_name': client,
      'debt': debt
    };
    try {
      final response = await http.post(
        url,
        body: body,
      );
      if (response.statusCode == 200) {
        print('Solicitud POST exitosa');
        print('Respuesta: ${response.body}');
        return true;
      } else {
        print('Error: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return false;
    }
  }

  List<String> getDetails(List<dynamic> products, String id, String quantity) {
    List<Map<String, String>> _products = (products)
        .map((item) => (item as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString())))
        .toList();
    int index = _products.indexWhere((elemento) => elemento['id'] == id);
    String name = _products[index]['name']!;
    String value =
        (double.parse(_products[index]['price']!) * int.parse(quantity))
            .toString();
    return [name, value];
  }
}
