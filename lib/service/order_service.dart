import 'package:autoparts/Model/order_history_model.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/cart_item_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderService {
  emptyCartNow(BuildContext context) {
    AutoParts.sharedPreferences
        .setStringList(AutoParts.userCartList, ["garbageValue"]);
    List tempList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userCartList);
    FirebaseFirestore.instance
        .collection("users")
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({
      AutoParts.userCartList: tempList,
    }).then((value) {
      AutoParts.sharedPreferences
          .setStringList(AutoParts.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  deleteCart(BuildContext context, String productId) {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('carts')
        .doc(productId)
        .delete()
        .whenComplete(() {
      emptyCartNow(context);
    });
  }

  addOrderHistory(String orderId, String productId, String pName, String pImage,
      int orginalPrice, int newPrice, int quantity, BuildContext context) {
    final model = OrderHistoyModel(
      orderHistoyId: orderId,
      productId: productId,
      pName: pName,
      pImage: pImage,
      orginalPrice: orginalPrice,
      newPrice: newPrice,
      quantity: quantity,
    ).toJson();
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection("orderHistory")
        .doc()
        .set(model)
        .whenComplete(() {
      addOrderHistoryForAdmin(orderId, productId, pName, pImage, orginalPrice,
          newPrice, quantity, context);
    }).whenComplete(() {
      for (int i = 0;
          i <
              AutoParts.sharedPreferences
                  .getStringList(AutoParts.userCartList)
                  .length;
          i++) {
        deleteCart(
          context,
          AutoParts.sharedPreferences.getStringList(AutoParts.userCartList)[i],
        );
      }
    });
  }

  addOrderHistoryForAdmin(
      String orderId,
      String productId,
      String pName,
      String pImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) {
    final model = OrderHistoyModel(
      orderHistoyId: orderId,
      productId: productId,
      pName: pName,
      pImage: pImage,
      orginalPrice: orginalPrice,
      newPrice: newPrice,
      quantity: quantity,
    ).toJson();
    AutoParts.firestore.collection("orderHistory").doc().set(model);
  }

  Future writeOrderDetailsForUser(String orderId, String addressId,
      int totalPrice, String paymentMethod, BuildContext context) async {
    await AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection(AutoParts.collectionOrders)
        .doc(orderId)
        .set({
      "orderId": orderId,
      AutoParts.addressID: addressId,
      AutoParts.totalPrice: totalPrice,
      "orderBy": AutoParts.sharedPreferences.getString(AutoParts.userUID),
      AutoParts.productID:
          AutoParts.sharedPreferences.getStringList(AutoParts.userCartList),
      AutoParts.paymentDetails: paymentMethod,
      "orderTime": DateTime.now(),
      AutoParts.isSuccess: true,
    }).whenComplete(() {
      writeOrderDetailsForAdmin(
          orderId, addressId, totalPrice, paymentMethod, context);
    });
  }

  Future writeOrderDetailsForAdmin(String orderId, String addressId,
      int totalPrice, String paymentMethod, BuildContext context) async {
    await AutoParts.firestore
        .collection(AutoParts.collectionOrders)
        .doc(orderId)
        .set({
      "orderId": orderId,
      AutoParts.addressID: addressId,
      AutoParts.totalPrice: totalPrice,
      "orderBy": AutoParts.sharedPreferences.getString(AutoParts.userUID),
      AutoParts.productID:
          AutoParts.sharedPreferences.getStringList(AutoParts.userCartList),
      AutoParts.paymentDetails: paymentMethod,
      "orderTime": DateTime.now(),
      "orderRecived": "UnDone",
      "orderRecivedTime": DateTime.now(),
      "beingPrePared": "UnDone",
      "beingPreParedTime": DateTime.now(),
      "onTheWay": "UnDone",
      "onTheWayTime": DateTime.now(),
      "deliverd": "UnDone",
      "deliverdTime": DateTime.now(),
      AutoParts.isSuccess: true,
    });
  }
}
