import 'package:flutter/material.dart';

class AddressChange with ChangeNotifier {
  int _counter = 0;
  int get count => _counter;
  displayResult(int v) {
    _counter = v;
    notifyListeners();
  }
}
