import 'package:autoparts/Model/product_model.dart';
import 'package:autoparts/Screens/products/product_details.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/service/cart_service.dart';
import 'package:autoparts/service/wishlist_service.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HorizontalCard extends StatelessWidget {
  final String cardTitle;
  final Stream stream;

  const HorizontalCard({
    Key key,
    this.cardTitle,
    this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Text(
              cardTitle,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Brand-Bold",
                letterSpacing: 0.5,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Text('');
              }
              return Container(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    ProductModel productModel =
                        ProductModel.fromJson(snapshot.data.docs[index].data());
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              height: 170,
                              width: 290,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  left: 5,
                                  right: 5,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            productModel.productImgUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 155,
                                      height: 150,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            productModel.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .branding_watermark_outlined,
                                              ),
                                              SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  productModel.brandName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: "Brand-Regular",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          (productModel.offervalue.toInt() < 1)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Text(
                                                    "\৳${productModel.orginalprice}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Brand-Regular",
                                                      fontSize: 16,
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      fontWeight:
                                                          FontWeight.w800,
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
                                                        fontFamily:
                                                            "Brand-Regular",
                                                        fontSize: 16,
                                                        color: Colors
                                                            .deepOrangeAccent,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "\৳${productModel.orginalprice}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Brand-Regular",
                                                            fontSize: 16,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          '- ${productModel.offervalue}%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Brand-Regular",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(AutoParts.collectionUser)
                                    .doc(AutoParts.sharedPreferences
                                        .getString(AutoParts.userUID))
                                    .collection('wishLists')
                                    .where("productId",
                                        isEqualTo: productModel.productId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return Container();
                                  return Center(
                                    child: IconButton(
                                      icon: (snapshot.data.docs.length == 1)
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.deepOrangeAccent,
                                            )
                                          : Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                      onPressed: () {
                                        WishListService().addWish(
                                          productModel.productId,
                                          productModel.productName,
                                          productModel.brandName,
                                          productModel.productImgUrl,
                                          productModel.newprice,
                                        );
                                        Fluttertoast.showToast(
                                          msg:
                                              "Item Added to WishList Successfully.",
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 14,
                            right: 4,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection(AutoParts.collectionUser)
                                      .doc(AutoParts.sharedPreferences
                                          .getString(AutoParts.userUID))
                                      .collection('carts')
                                      .where("productId",
                                          isEqualTo: productModel.productId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Container();
                                    return IconButton(
                                      icon: (snapshot.data.docs.length == 1)
                                          ? Icon(
                                              Icons.shopping_bag,
                                              size: 25,
                                              color: Colors.white,
                                            )
                                          : Icon(
                                              Icons.add_shopping_cart_outlined,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                      onPressed: () {
                                        (productModel.status == 'Available')
                                            ? CartService().checkItemInCart(
                                                productModel.productId,
                                                productModel.productName,
                                                productModel.productImgUrl,
                                                productModel.newprice,
                                                productModel.newprice =
                                                    productModel.newprice *
                                                        quantity,
                                                quantity,
                                                context,
                                              )
                                            : Fluttertoast.showToast(
                                                msg:
                                                    "This Product is now not available",
                                              );
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
