import 'package:autoparts/Screens/products/category_products.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String imageUrl, categoryName;
  CategoryTile({
    this.imageUrl,
    this.categoryName,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.mobile &&
            connectivityResult != ConnectivityResult.wifi) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "No Internet Connection",
                ),
                content: Text("Check your network settings and try again."),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProducts(category: categoryName),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imageUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
