import 'package:flutter/material.dart';

AppBar simpleAppBar(bool isMainTitle, String title) {
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrangeAccent, Colors.orange],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    ),
    title: Text(
      isMainTitle ? "AutoParts" : title,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
        fontFamily: "Brand-Regular",
      ),
    ),
    centerTitle: true,
  );
}
