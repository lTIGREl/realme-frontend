import 'dart:convert';
import 'package:http/http.dart' as http;

class LogIn {
  LogIn(this.user, this.password);
  String user;
  String password;
  String baseUrl = 'http://192.168.1.68:4000/api/auth/login';
  //'https://realme.up.railway.app/api/auth/login';

  Future<bool> enviarSolicitudLogin() async {
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
      http.Response respuesta = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', // Especificar el tipo de contenido como JSON
        },
        body: cuerpoSolicitud,
      );
      print(respuesta.statusCode);
      // Verificar el código de estado de la respuesta
      if (respuesta.statusCode == 200) {
        // La solicitud fue exitosa, puedes procesar la respuesta aquí
        // print('Respuesta exitosa: ${respuesta.body}');
        return true;
      } else {
        // Hubo un error en la solicitud, puedes manejarlo aquí
        // print('Error en la solicitud: ${respuesta.statusCode}');
        return false;
      }
    } catch (error) {
      // Error al enviar la solicitud
      print('Error: $error');
      return false;
    }
  }
}
