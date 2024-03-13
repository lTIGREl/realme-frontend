import 'package:http/http.dart' as http;
import 'dart:convert';

class Membership {
  String id;
  String client_id;
  String iDate;
  String fDate;

  Membership(
      {required this.id,
      this.client_id = '',
      this.iDate = '',
      this.fDate = ''});

  Future<List<dynamic>?> getMembership() async {
    final url =
        Uri.parse('https://realme.up.railway.app/api/membresias/client_id/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> membresia = body['body'];
        return membresia;
      } else {
        print('Error: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }

  Future<bool> postMembership() async {
    final url = Uri.parse('https://realme.up.railway.app/api/membresias');
    final Map<String, dynamic> body = {
      "id": id,
      "client_id": client_id,
      "start_date": iDate,
      "end_date": fDate
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

  Future<bool> deleteMembership(String column, String value) async {
    final url = Uri.parse('https://realme.up.railway.app/api/membresias');
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
