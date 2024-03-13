import 'package:flutter/cupertino.dart';

class DeleteOption with ChangeNotifier {
  bool _needDelete = false;

  bool get needDelete => _needDelete;

  set needDelete(bool needDelete) {
    _needDelete = needDelete;
    notifyListeners();
  }
}
