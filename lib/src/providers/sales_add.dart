import 'package:flutter/cupertino.dart';

class SelectedItemSale with ChangeNotifier {
  String _product = 'Diario';
  String _mode = 'Efectivo';
  int _quantity = 1;
  int _costumer = 0000000000;

  String get mode => _mode;

  set mode(String modality) {
    _mode = modality;
    notifyListeners();
  }

  int get costumer => _costumer;
  set costumer(int costumer) {
    _costumer = costumer;
    notifyListeners();
  }

  int get quantity => _quantity;

  set quantity(int cantidad) {
    if (cantidad <= 0) {
      cantidad = 1;
    }
    _quantity = cantidad;
    notifyListeners();
  }

  String get product => _product;

  set product(String producto) {
    _product = producto;
    notifyListeners();
  }
}
