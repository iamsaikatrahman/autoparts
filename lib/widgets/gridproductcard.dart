import 'package:autoparts/Model/product_model.dart';
import 'package:autoparts/Screens/products/product_details.dart';
import 'package:autoparts/service/cart_service.dart';
import 'package:autoparts/service/wishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GridProductCard extends StatelessWidget {
  const GridProductCard({
    Key key,
    @required this.quantity,
    @required this.itemCount,
    @required this.snapshotlist,
  }) : super(key: key);

  final int quantity;
  final int itemCount;
  final List<QueryDocumentSnapshot> snapshotlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (BuildContext context, int index) {
          ProductModel productModel =
              ProductModel.fromJson(snapshotlist[index].data());
          return GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (c) => ProductDetails(
                        productModel: productModel,
                      ));
              Navigator.push(context, route);
            },
            child: Stack(
              children: [
                Card(
                  elevation: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          productModel.productImgUrl,
                          width: 150,
                          height: 100,
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productModel.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.branding_watermark_outlined),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      productModel.brandName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              (productModel.offervalue < 1)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "\৳${productModel.orginalprice}",
                                        style: TextStyle(
                                          fontFamily: "Brand-Regular",
                                          fontSize: 16,
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\৳${productModel.newprice}",
                                          style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            fontSize: 16,
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\৳${productModel.orginalprice}",
                                              style: TextStyle(
                                                fontFamily: "Brand-Regular",
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '- ${productModel.offervalue}%',
                                              style: TextStyle(
                                                fontFamily: "Brand-Regular",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          spreadRadius: -2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite_outline_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        onPressed: () {
                          WishListService().checkItemInWishList(
                            productModel.productId,
                            productModel.productName,
                            productModel.brandName,
                            productModel.productImgUrl,
                            productModel.newprice,
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        CartService().checkItemInCart(
                          productModel.productId,
                          productModel.productName,
                          productModel.productImgUrl,
                          productModel.newprice,
                          productModel.newprice =
                              productModel.newprice * quantity,
                          quantity,
                          
                          context,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
