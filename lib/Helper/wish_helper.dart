import 'package:autoparts/Model/wish_model.dart';
import 'package:autoparts/Screens/cart_screen.dart';
import 'package:autoparts/Screens/products/product_search.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/cart_item_counter.dart';
import 'package:autoparts/service/cart_service.dart';
import 'package:autoparts/service/wishlist_service.dart';
import 'package:autoparts/widgets/emptycardmessage.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class WishHelper {
  Widget wishAppBar(BuildContext context) {
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "WishList",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              fontFamily: "Brand-Regular",
            ),
          ),
          SizedBox(width: 5),
          Text(
            "(",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(AutoParts.collectionUser)
                .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
                .collection('wishLists')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('');
              }
              return Text(
                snapshot.data.docs.length.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          Text(
            ")",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => CartScreen());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              top: 3,
              left: 3,
              child: Stack(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                        border: Border.all(color: Colors.orangeAccent)),
                  ),
                  ((AutoParts.sharedPreferences
                                  .getStringList(AutoParts.userCartList)
                                  .length -
                              1) <
                          10)
                      ? Positioned(
                          top: 2,
                          bottom: 4,
                          left: 6,
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                              return Text(
                                (AutoParts.sharedPreferences
                                            .getStringList(
                                                AutoParts.userCartList)
                                            .length -
                                        1)
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        )
                      : Positioned(
                          top: 3,
                          bottom: 2,
                          left: 3,
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                              return Text(
                                (AutoParts.sharedPreferences
                                            .getStringList(
                                                AutoParts.userCartList)
                                            .length -
                                        1)
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.search_outlined,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (_) => ProductSearch());
            Navigator.push(context, route);
          },
        ),
      ],
    );
  }

  Widget wishlistItems() {
    int quantity = 1;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(AutoParts.collectionUser)
          .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
          .collection('wishLists')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        return (snapshot.data.docs.length == 0)
            ? EmptyCardMessage(
                listTitle: "WishList is empty",
                message: "Start adding items to your WishList",
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.88,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    WishModel wishModel = WishModel.fromJson(
                      snapshot.data.docs[index].data(),
                    );
                    return Stack(
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: 10,
                              right: 10,
                            ),
                            child: ListTile(
                              leading: Image.network(
                                wishModel.pImage,
                              ),
                              title: Column(
                                children: [
                                  Text(
                                    wishModel.pName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.branding_watermark_outlined),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          wishModel.pBrand,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: Text(
                                  '\৳${wishModel.newPrice}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () {
                              WishListService().deleteWish(
                                wishModel.productId,
                                // context,
                              );
                              Fluttertoast.showToast(
                                  msg: "Item Removed Successfully.");
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            height: 35,
                            width: 70,
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
                                        isEqualTo: wishModel.productId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return Container();
                                  return IconButton(
                                    icon: (snapshot.data.docs.length == 1)
                                        ? Icon(
                                            Icons.shopping_bag,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.add_shopping_cart_outlined,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                    onPressed: () {
                                      CartService().checkItemInCart(
                                        wishModel.productId,
                                        wishModel.pName,
                                        wishModel.pImage,
                                        wishModel.newPrice,
                                        wishModel.newPrice =
                                            wishModel.newPrice * quantity,
                                        quantity,
                                        context,
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
