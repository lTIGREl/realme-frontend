import 'package:http/http.dart' as http;
import 'dart:convert';

class Routine {
  Map<String, String> data;
  late String id;
  late String day;
  late String main;
  late String complementary;
  late String cardio;
  Routine(
      {this.data = const {
        'id': '',
        'day': '',
        'main': '',
        'complementary': '',
        'cardio': ''
      }}) {
    id = data['id']!;
    day = data['day']!;
    main = data['main']!;
    complementary = data['complementary']!;
    cardio = data['cardio']!;
  }
  Future<List<dynamic>> getRoutines(bool needRefresh) async {
    final url = needRefresh
        ? Uri.parse('https://realme.up.railway.app/api/rutinas')
        : Uri.parse('https://realme.up.railway.app/api/rutinas');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> rutinas = body['body'];
        return rutinas;
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

  Future<bool> postRoutines() async {
    final url = Uri.parse('https://realme.up.railway.app/api/rutinas');
    final Map<String, dynamic> body = {
      "id": id,
      "day": day,
      "main": main,
      "complementary": complementary,
      "cardio": cardio
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
}
