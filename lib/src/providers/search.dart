import 'package:flutter/cupertino.dart';
import 'package:real_me_fitness_center/src/models/client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SearchOption with ChangeNotifier {
  String _column = '';
  String _value = '';
  bool _needSearch = false;
  String baseUrl = 'http://192.168.0.104:4000';
  //'https://realme.up.railway.app';
  late IO.Socket socket;
  SearchOption() {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('newClient', (data) {
      needSearch = true;
    });

    socket.connect();
  }

  @override
  void dispose() {
    print('Dispose');
    socket.disconnect();
    super.dispose();
  }

  String get column => _column;

  set column(String column) {
    _column = column;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  bool get needSearch => _needSearch;

  set needSearch(bool needSearch) {
    _needSearch = needSearch;
    notifyListeners();
  }

  Future<List<dynamic>> fetchData() async {
    Client client = Client();
    List<dynamic> result = await client.getClients(needSearch, column, value);
    return result;
  }
}
