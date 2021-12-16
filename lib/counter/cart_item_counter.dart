import 'package:autoparts/config/config.dart';
import 'package:flutter/material.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = AutoParts.sharedPreferences
          .getStringList(AutoParts.userCartList)
          .length -
      1; 
  int get count => _counter;

  Future<void> displayResult() async {
     int _counter = AutoParts.sharedPreferences
          .getStringList(AutoParts.userCartList)
          .length -
      1;

      await Future.delayed(const Duration(milliseconds: 100),(){
        notifyListeners();
      });
  }
}
