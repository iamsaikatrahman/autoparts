import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String message;
  final Function onPressed;

  const WideButton({Key key, this.message, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                message.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Brand-Regular",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
