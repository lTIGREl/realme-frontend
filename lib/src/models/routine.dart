import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:real_me_fitness_center/src/configs/api.dart';

class Routine {
  Map<String, String> data;
  late String id;
  late String day;
  late String main;
  late String complementary;
  late String cardio;
  String baseUrl = '${ApiConfig().baseUrl}rutinas';
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
  Future<List<Map<String, String>>> getRoutines(bool needRefresh) async {
    final url = needRefresh ? Uri.parse(baseUrl) : Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> rutinas = body['body'];
        List<Map<String, String>> datos = (rutinas)
            .map((item) => (item as Map<String, dynamic>).map(
                (key, value) => MapEntry(key.toString(), value.toString())))
            .toList();
        return datos;
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
    final url = Uri.parse(baseUrl);
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
