import 'package:autoparts/Model/wish_model.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/wishlist_item_count.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class WishListService {
  checkItemInWishList(String productId, String pName, String pBrand,
      String pImage, int newPrice, BuildContext context) {
    AutoParts.sharedPreferences
            .getStringList(AutoParts.userWishList)
            .contains(productId)
        ? Fluttertoast.showToast(msg: "Item is already in WishList.")
        : addItemToWishList(
            productId, pName, pBrand, pImage, newPrice, context);
  }

  addItemToWishList(String productId, String pName, String pBrand,
      String pImage, int newPrice, BuildContext context) async {
    List tempWishList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userWishList);
    tempWishList.add(productId);

    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({AutoParts.userWishList: tempWishList}).then((v) {
      Fluttertoast.showToast(msg: "Item Added to WishList Successfully.");

      AutoParts.sharedPreferences
          .setStringList(AutoParts.userWishList, tempWishList);
      Provider.of<WishListItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        addWish(productId, pName, pBrand, pImage, newPrice);
      });
    });
  }

  addWish(String productId, String pName, String pBrand, String pImage,
      int newPrice) {
    final model = WishModel(
      wishId: productId,
      productId: productId,
      pName: pName,
      pBrand: pBrand,
      pImage: pImage,
      newPrice: newPrice,
    ).toJson();

    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('wishLists')
        .doc(productId)
        .set(model);
  }

  removeItemFromUserWishList(String productId, BuildContext context) {
    List tempWishList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userWishList);
    tempWishList.remove(productId);
    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({
      AutoParts.userWishList: tempWishList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item Removed Successfully.");
      AutoParts.sharedPreferences
          .setStringList(AutoParts.userWishList, tempWishList);
      Provider.of<WishListItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        deleteWish(productId);
      });
    });
  }

  deleteWish(String productId) {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('wishLists')
        .doc(productId)
        .delete();
  }
}
