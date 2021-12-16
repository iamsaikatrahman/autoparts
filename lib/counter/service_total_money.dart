import 'package:flutter/material.dart';

class ServiceTotalPrice with ChangeNotifier {
  int _servicetotalPrice = 0;
  int get totalPrice => _servicetotalPrice;
  display(int no) async {
    _servicetotalPrice = no;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
