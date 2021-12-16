import 'package:autoparts/Helper/wish_helper.dart';
import 'package:flutter/material.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WishHelper().wishAppBar(context),
     
      body: Container(
        child: Column(
          children: [
            WishHelper().wishlistItems(),
          ],
        ),
      ),
    );
  }
}
