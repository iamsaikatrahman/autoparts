import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key key,
    @required this.controller,
    @required this.hintText,
    @required this.labelText,
    @required this.maxLine,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: "Brand-Regular",
        ),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Brand-Regular",
            ),
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
