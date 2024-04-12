import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:real_me_fitness_center/src/configs/api.dart';

class Sale {
  String baseUrl = '${ApiConfig().baseUrl}compras';
  //'https://realme.up.railway.app/api/clientes';
  Future<bool> postSale(String quantity, String product, String mode,
      String client, String debt) async {
    final url = Uri.parse(baseUrl);
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
}
