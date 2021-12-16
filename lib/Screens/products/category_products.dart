import 'package:autoparts/widgets/gridproductcard.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:autoparts/widgets/mycustom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProducts extends StatefulWidget {
  final String category;

  const CategoryProducts({Key key, this.category}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    return Scaffold(
      appBar: MyCustomAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("categoryName", isEqualTo: widget.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return GridProductCard(
            itemCount: snapshot.data.docs.length,
            snapshotlist: snapshot.data.docs,
            quantity: quantity,
          );
        },
      ),
    );
  }
}
