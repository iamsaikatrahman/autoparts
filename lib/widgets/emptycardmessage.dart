import 'package:flutter/material.dart';

class EmptyCardMessage extends StatelessWidget {
  final String listTitle;
  final String message;
  const EmptyCardMessage({
    Key key,
    this.listTitle,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.withOpacity(0.5),
      child: Container(
        width: double.infinity,
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_emoticon, color: Colors.white),
            SizedBox(height: 10),
            Text(
              listTitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
