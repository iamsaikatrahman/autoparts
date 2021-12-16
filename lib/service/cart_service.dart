import 'package:autoparts/Model/cart_model.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/cart_item_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartService {
  checkItemInCart( 
      String productId,
      String pName,
      String pImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) {
    AutoParts.sharedPreferences
            .getStringList(AutoParts.userCartList)
            .contains(productId)
        ? Fluttertoast.showToast(msg: "Item is already in Cart.")
        : addItemToCart(productId, pName, pImage, orginalPrice, newPrice,
            quantity, context);
  }

  addItemToCart(
      String productId,
      String pName,
      String pImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) async {
    List tempCartList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userCartList);
    tempCartList.add(productId);

    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({AutoParts.userCartList: tempCartList}).then((v) {
      Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

      AutoParts.sharedPreferences
          .setStringList(AutoParts.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        addCart(productId, pName, pImage, orginalPrice, newPrice, quantity,
             context);
      });
    });
  }

  addCart(
    String productId,
    String pName,
    String pImage,
    int orginalPrice,
    int newPrice,
    int quantity,
    BuildContext context,
  ) {
    final model = CartModel(
      cartId: productId,
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
        .collection('carts')
        .doc(productId)
        .set(model);
  }

  updateCart(String productId, String pName, String pImage, int orginalPrice,
      int newPrice, int quantity, String quantitylist, BuildContext context) {
    final model = CartModel(
      cartId: productId,
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
        .collection('carts')
        .doc(productId)
        .update(model);
  }

  removeItemFromUserCart(String productId, int totalPrice, String quantitylist,
      BuildContext context) {
    List tempCartList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userCartList);
    tempCartList.remove(productId);
    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({
      AutoParts.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item Removed Successfully.");
      AutoParts.sharedPreferences
          .setStringList(AutoParts.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        deleteCart(productId, quantitylist, context);
      });
      totalPrice = 0;
    });
  }

  deleteCart(String productId, String quantitylist, BuildContext context) {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('carts')
        .doc(productId)
        .delete();
  }
}
