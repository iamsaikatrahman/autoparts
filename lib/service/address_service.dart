import 'package:autoparts/Model/addresss.dart';
import 'package:autoparts/config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressService {
  String addressId = DateTime.now().microsecondsSinceEpoch.toString();
  addAddress(String cName, String cPhoneNumber, String houseandroadno,
      String city, String area, String areacode) {
    final model = AddressModel(
      addressId: addressId,
      customerName: cName,
      phoneNumber: cPhoneNumber,
      houseandroadno: houseandroadno,
      city: city,
      area: area,
      areacode: areacode,
    ).toJson();
    FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection(AutoParts.subCollectionAddress)
        .doc(addressId)
        .set(model)
        .whenComplete(() {
      addAddressForAdmin(
          cName, cPhoneNumber, houseandroadno, city, area, areacode);
    }).then((value) {
      Fluttertoast.showToast(msg: "New Address added successfully.");
    });
  }

  addAddressForAdmin(String cName, String cPhoneNumber, String houseandroadno,
      String city, String area, String areacode) {
    final model = AddressModel(
      addressId: addressId,
      customerName: cName,
      phoneNumber: cPhoneNumber,
      houseandroadno: houseandroadno,
      city: city,
      area: area,
      areacode: areacode,
    ).toJson();
    FirebaseFirestore.instance
        .collection("useraddress")
        .doc(addressId)
        .set(model);
  }
}
