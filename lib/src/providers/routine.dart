import 'package:flutter/foundation.dart';
import 'package:real_me_fitness_center/src/models/routine.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoutineProvider with ChangeNotifier {
  bool _needRefresh = false;
  bool get needRefresh => _needRefresh;
  String baseUrl = 'http://192.168.1.68:4000';
  //'https://realme.up.railway.app';

  RoutineProvider() {
    _initSocket();
  }

  void _initSocket() {
    IO.Socket socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('newRoutine', (data) {
      needRefresh = true;
    });

    socket.connect();
  }

  set needRefresh(bool needRefresh) {
    _needRefresh = needRefresh;
    if (needRefresh) {
      notifyListeners();
    }
  }

  Future<List<dynamic>> getRoutine() async {
    needRefresh = false;
    Routine routine = Routine();
    List<dynamic> result = await routine.getRoutines(needRefresh);
    List<Map<String, String>> datos = (result as List)
        .map((item) => (item as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString())))
        .toList();
    return datos;
  }
}
