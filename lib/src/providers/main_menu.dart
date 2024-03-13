import 'package:flutter/cupertino.dart';

class SelectedPageModel with ChangeNotifier {
  int _page = 0;
  int get page => this._page;
  set page(int actPage) {
    this._page = actPage;
    notifyListeners();
  }
}
