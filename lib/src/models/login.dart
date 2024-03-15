import 'dart:convert';
import 'package:http/http.dart' as http;

class LogIn {
  LogIn(this.user, this.password);
  String user;
  String password;
  String baseUrl = 'http://192.168.1.68:4000/api/auth/login';
  //'https://realme.up.railway.app/api/auth/login';

  Future<String> enviarSolicitudLogin() async {
    // Construir el cuerpo de la solicitud en formato JSON
    Map<String, String> datos = {
      'user': user,
      'password': password,
    };

    // Convertir los datos a JSON
    String cuerpoSolicitud = json.encode(datos);

    // Configurar la URL de la solicitud
    Uri url = Uri.parse(baseUrl);

    try {
      // Enviar la solicitud POST
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: cuerpoSolicitud,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final String token = body['body'];
        return token;
        // La solicitud fue exitosa, puedes procesar la respuesta aquí
        // print('Respuesta exitosa: ${respuesta.body}');
      } else {
        // Hubo un error en la solicitud, puedes manejarlo aquí
        // print('Error en la solicitud: ${respuesta.statusCode}');
        return "";
      }
    } catch (error) {
      // Error al enviar la solicitud
      return "";
    }
  }
}
