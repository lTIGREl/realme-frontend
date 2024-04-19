import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:real_me_fitness_center/src/configs/api.dart';

class Client {
  Map<String, String> data;
  late String id;
  late String name;
  late String ic;
  late String BDate;
  String _baseUrl = '${ApiConfig().baseUrl}clientes';
  //'https://realme.up.railway.app/api/clientes';

  Client(
      {this.id = '',
      this.data = const {'id': '', 'name': '', 'ic': '', 'BDate': ''}}) {
    id = data['id']!;
    name = data['name']!;
    ic = data['ic']!;
    BDate = data['BDate']!;
  }

  Future<List<dynamic>> getClients(
      bool needSearch, String column, String value) async {
    final url = needSearch
        ? Uri.parse('$_baseUrl/$column/$value')
        : Uri.parse(_baseUrl);
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

  Future<bool> postClient() async {
    final url = Uri.parse(_baseUrl);
    final Map<String, dynamic> body = {
      "id": id,
      "name": name,
      "ic": ic,
      "BDate": BDate
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

  Future<bool> deleteClient(String column, String value) async {
    final url = Uri.parse(_baseUrl);
    final Map<String, dynamic> body = {"column": column, "value": value};
    try {
      final response = await http.put(
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
}
