import 'package:flutter/cupertino.dart';

class SelectedDateModel with ChangeNotifier {
  DateTime _iDate = DateTime.now();
  DateTime _fDate = DateTime.now();

  DateTime get iDate => this._iDate;
  set iDate(DateTime date) {
    this._iDate = date;
    notifyListeners();
  }

  DateTime get fDate => this._fDate;
  set fDate(DateTime date) {
    this._fDate = date;
    notifyListeners();
  }
}
