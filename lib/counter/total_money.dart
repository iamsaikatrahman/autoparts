import 'package:flutter/material.dart';

class TotalAmount with ChangeNotifier {
  int _totalPrice = 0;
  int get totalPrice => _totalPrice;
  display(int no) async {
    _totalPrice = no;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
