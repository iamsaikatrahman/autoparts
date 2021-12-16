import 'package:autoparts/Model/cart_model.dart';

import 'package:autoparts/Screens/Address/address.dart';

import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/cart_item_counter.dart';
import 'package:autoparts/counter/total_money.dart';
import 'package:autoparts/service/cart_service.dart';
import 'package:autoparts/widgets/emptycardmessage.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:autoparts/widgets/mycustomdrawer.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int totalPrice;

  @override
  void initState() {
    super.initState();
    totalPrice = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(false, "My Cart"),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(AutoParts.collectionUser)
              .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
              .collection('carts')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return (snapshot.data.docs.length == 0)
                ? Container()
                : FloatingActionButton.extended(
                    onPressed: () {
                      if (AutoParts.sharedPreferences
                              .getStringList(AutoParts.userCartList)
                              .length ==
                          1) {
                        Fluttertoast.showToast(msg: "Your cart is empty.");
                      } else {
                        Route route = MaterialPageRoute(
                            builder: (c) => Address(
                                  totalPrice: totalPrice,
                                ));
                        Navigator.push(context, route);
                      }
                    },
                    label: Text(
                      "CHECKOUT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.deepOrangeAccent[200],
                    icon: Icon(Icons.shopping_cart_outlined),
                  );
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: ((AutoParts.sharedPreferences
                                    .getStringList(AutoParts.userCartList)
                                    .length -
                                1) ==
                            0)
                        ? Container()
                        : Text(
                            "Total Price: \৳ ${amountProvider.totalPrice.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(AutoParts.collectionUser)
                  .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
                  .collection('carts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(
                    child: circularProgress(),
                  );
                return (snapshot.data.docs.length == 0)
                    ? EmptyCardMessage(
                        listTitle: "Cart is empty",
                        message: "Start adding items to your Cart",
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            CartModel cartModel = CartModel.fromJson(
                                snapshot.data.docs[index].data());

                            if (index == 0) {
                              totalPrice = 0;
                              totalPrice = cartModel.newPrice + totalPrice;
                            } else {
                              totalPrice = cartModel.newPrice + totalPrice;
                            }

                            if (snapshot.data.docs.length - 1 == index) {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false)
                                    .display(totalPrice);
                              });
                            }
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                leading: Image.network(
                                  cartModel.pImage,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartModel.pName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: OutlineButton.icon(
                                            padding: EdgeInsets.zero,
                                            color:
                                                Theme.of(context).accentColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            icon: Icon(
                                              Icons.delete_outline_outlined,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                            label: Text(
                                              'Remove',
                                              style: TextStyle(
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                CartService()
                                                    .removeItemFromUserCart(
                                                  cartModel.productId,
                                                  totalPrice,
                                                  cartModel.quantity.toString(),
                                                  context,
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: OutlineButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(Icons.remove,
                                                    size: 18),
                                                onPressed: () {
                                                  if (cartModel.quantity > 1) {
                                                    setState(() {
                                                      cartModel.quantity--;
                                                    });
                                                    CartService().updateCart(
                                                      cartModel.productId,
                                                      cartModel.pName,
                                                      cartModel.pImage,
                                                      cartModel.orginalPrice,
                                                      cartModel
                                                          .newPrice = cartModel
                                                              .orginalPrice *
                                                          cartModel.quantity,
                                                      cartModel.quantity,
                                                      cartModel.quantity
                                                          .toString(),
                                                      context,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              child: Text(
                                                '${cartModel.quantity}',
                                                style: TextStyle(
                                                  fontFamily: "Brand-Regular",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: OutlineButton(
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child:
                                                    Icon(Icons.add, size: 18),
                                                onPressed: () {
                                                  setState(() {
                                                    cartModel.quantity++;
                                                  });
                                                  CartService().updateCart(
                                                    cartModel.productId,
                                                    cartModel.pName,
                                                    cartModel.pImage,
                                                    cartModel.orginalPrice,
                                                    cartModel.newPrice =
                                                        cartModel.orginalPrice *
                                                            cartModel.quantity,
                                                    cartModel.quantity,
                                                    cartModel.quantity
                                                        .toString(),
                                                    context,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      '\৳${cartModel.newPrice}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
