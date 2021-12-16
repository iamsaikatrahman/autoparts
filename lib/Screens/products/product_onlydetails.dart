import 'package:autoparts/Model/product_model.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:flutter/material.dart';

class ProductOnlyDetails extends StatelessWidget {
  final ProductModel productModel;

  const ProductOnlyDetails({Key key, this.productModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        false,
        "Product Details",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Specifications of  product",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Brand-Bold",
                ),
              ),
              SizedBox(height: 4),
              Text(
                productModel.shortInfo.replaceAll("\\n", "\n"),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Brand-Regular",
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Product Details",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Brand-Bold",
                ),
              ),
              SizedBox(height: 4),
              Text(
                productModel.description.replaceAll("\\n", "\n"),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Brand-Regular",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
