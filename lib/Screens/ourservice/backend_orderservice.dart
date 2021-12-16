import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/service_item_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BackEndOrderService {
  checkServiceInCart(
      String serviceId,
      int newPrice,
      int orginalPrice,
      String serviceImage,
      String serviceName,
      String date,
      int quantity,
      BuildContext context) {
    AutoParts.sharedPreferences
            .getStringList(AutoParts.userServiceList)
            .contains(serviceId)
        ? Fluttertoast.showToast(msg: "Item is already in Cart.")
        : addServiceToCart(serviceId, newPrice, orginalPrice, serviceImage,
            serviceName, date, quantity, context);
  }

  addServiceToCart(
      String serviceId,
      int newPrice,
      int orginalPrice,
      String serviceImage,
      String serviceName,
      String date,
      int quantity,
      BuildContext context) async {
    List tempServiceList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userServiceList);
    tempServiceList.add(serviceId);

    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({AutoParts.userServiceList: tempServiceList}).then((v) {
      Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

      AutoParts.sharedPreferences
          .setStringList(AutoParts.userServiceList, tempServiceList);
      Provider.of<ServiceItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        addService(serviceId, newPrice, orginalPrice, serviceImage, serviceName,
            date, quantity);
      });
    });
  }

  Future addService(
    String serviceId,
    int newPrice,
    int orginalPrice,
    String serviceImage,
    String serviceName,
    String date,
    int quantity,
  ) async {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('ServiceCart')
        .doc(serviceId)
        .set({
      "servicecartId": serviceId,
      "serviceId": serviceId,
      "newPrice": newPrice,
      "date": date,
      "orginalPrice": orginalPrice,
      "serviceImage": serviceImage,
      "serviceName": serviceName,
      "quantity": quantity,
    });
  }

  removeServiceFromUserServiceCart(
      String serviceId, int totalPrice, BuildContext context) {
    List tempServiceList =
        AutoParts.sharedPreferences.getStringList(AutoParts.userServiceList);
    tempServiceList.remove(serviceId);
    AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({
      AutoParts.userServiceList: tempServiceList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item Removed Successfully.");
      AutoParts.sharedPreferences
          .setStringList(AutoParts.userServiceList, tempServiceList);
      Provider.of<ServiceItemCounter>(context, listen: false)
          .displayResult()
          .whenComplete(() {
        deleteService(serviceId);
      });
      totalPrice = 0;
    });
  }

  deleteService(String serviceId) {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('ServiceCart')
        .doc(serviceId)
        .delete();
  }

  addServiceOrderHistory(
      String orderId,
      String serviceId,
      String serviceName,
      String date,
      String serviceImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) {
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection("serviceorderHistory")
        .doc()
        .set({
      "orderHistoyId": orderId,
      "serviceId": serviceId,
      "newPrice": newPrice,
      "date": date,
      "orginalPrice": orginalPrice,
      "serviceImage": serviceImage,
      "serviceName": serviceName,
      "quantity": quantity,
    }).whenComplete(() {
      addServiceOrderHistoryForAdmin(orderId, serviceId, serviceName, date,
          serviceImage, orginalPrice, newPrice, quantity, context);
    }).whenComplete(() {
      // for (int i = 0;
      //     i <
      //         AutoParts.sharedPreferences
      //             .getStringList(AutoParts.userServiceList)
      //             .length;
      //     i++) {
      //   deleteServiceCart(
      //     context,
      //     AutoParts.sharedPreferences
      //         .getStringList(AutoParts.userServiceList)[i],
      //   );
      // }
    });
  }

  addServiceOrderHistoryForAdmin(
      String orderId,
      String serviceId,
      String serviceName,
      String date,
      String serviceImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) {
    AutoParts.firestore.collection("serviceorderHistory").doc().set({
      "orderHistoyId": orderId,
      "serviceId": serviceId,
      "newPrice": newPrice,
      "date": date,
      "orginalPrice": orginalPrice,
      "serviceImage": serviceImage,
      "serviceName": serviceName,
      "quantity": quantity,
    });
  }

  // deleteServiceCart(BuildContext context, String serviceId) {
  //   FirebaseFirestore.instance
  //       .collection(AutoParts.collectionUser)
  //       .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
  //       .collection('ServiceCart')
  //       .doc(serviceId)
  //       .delete()
  //       .whenComplete(() {
  //     emptyServicCartNow(context);
  //   });
  // }

  // emptyServicCartNow(BuildContext context) {
  //   AutoParts.sharedPreferences
  //       .setStringList(AutoParts.userServiceList, ["garbageValue"]);
  //   List tempServiceList =
  //       AutoParts.sharedPreferences.getStringList(AutoParts.userServiceList);
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
  //       .update({
  //     AutoParts.userServiceList: tempServiceList,
  //   }).then((value) {
  //     AutoParts.sharedPreferences
  //         .setStringList(AutoParts.userServiceList, tempServiceList);
  //     Provider.of<ServiceItemCounter>(context, listen: false).displayResult();
  //   });
  // }

  Future writeServiceOrderDetailsForUser(
      String orderId,
      String addressId,
      int totalPrice,
      String paymentMethod,
      String serviceId,
      String serviceName,
      String date,
      String serviceImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) async {
    await AutoParts.firestore
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection("serviceOrder")
        .doc(orderId)
        .set({
      "orderId": orderId,
      AutoParts.addressID: addressId,
      AutoParts.totalPrice: totalPrice,
      "orderBy": AutoParts.sharedPreferences.getString(AutoParts.userUID),
      // AutoParts.productID:
      //     AutoParts.sharedPreferences.getStringList(AutoParts.userServiceList),
      AutoParts.paymentDetails: paymentMethod,
      "orderTime": DateTime.now(),
      AutoParts.isSuccess: true,
      "serviceId": serviceId,
      "newPrice": newPrice,
      "date": date,
      "orginalPrice": orginalPrice,
      "serviceImage": serviceImage,
      "serviceName": serviceName,
      "quantity": quantity,
    }).whenComplete(() {
      writeServiceOrderDetailsForAdmin(
        orderId,
        addressId,
        totalPrice,
        paymentMethod,
        serviceId,
        serviceName,
        date,
        serviceImage,
        orginalPrice,
        newPrice,
        quantity,
        context,
      );
    }).whenComplete(() {
      deleteService(serviceId);
    });
  }

  Future writeServiceOrderDetailsForAdmin(
      String orderId,
      String addressId,
      int totalPrice,
      String paymentMethod,
      String serviceId,
      String serviceName,
      String date,
      String serviceImage,
      int orginalPrice,
      int newPrice,
      int quantity,
      BuildContext context) async {
    await AutoParts.firestore.collection("serviceOrder").doc(orderId).set({
      "orderId": orderId,
      AutoParts.addressID: addressId,
      AutoParts.totalPrice: totalPrice,
      "orderBy": AutoParts.sharedPreferences.getString(AutoParts.userUID),
      // AutoParts.productID:
      //     AutoParts.sharedPreferences.getStringList(AutoParts.userServiceList),
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
      "orderHistoyId": orderId,
      "serviceId": serviceId,
      "newPrice": newPrice,
      "date": date,
      "orginalPrice": orginalPrice,
      "serviceImage": serviceImage,
      "serviceName": serviceName,
      "quantity": quantity,
    });
  }
}
