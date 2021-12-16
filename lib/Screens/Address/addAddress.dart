import 'package:autoparts/service/address_service.dart';
import 'package:autoparts/widgets/erroralertdialog.dart';
import 'package:autoparts/widgets/mytextFormfield.dart';
import 'package:autoparts/widgets/noInternetConnectionAlertDialog.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cHouseandRoadNumber = TextEditingController();
  final cCity = TextEditingController();
  final cArea = TextEditingController();
  final cAreaCode = TextEditingController();
  final AddressService _addressService = AddressService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(false, "Add Address"),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: RaisedButton(
            child: Text(
              "Add Address".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Brand-Bold",
                letterSpacing: 1.5,
                fontSize: 18,
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoInternetConnectionAlertDialog();
                  },
                );
              }
              if (cName.text.isNotEmpty &&
                  cPhoneNumber.text.isNotEmpty &&
                  cHouseandRoadNumber.text.isNotEmpty &&
                  cCity.text.isNotEmpty &&
                  cArea.text.isNotEmpty &&
                  cAreaCode.text.isNotEmpty) {
                _addressService.addAddress(
                  cName.text.trim(),
                  cPhoneNumber.text.trim(),
                  cHouseandRoadNumber.text.trim(),
                  cCity.text.trim(),
                  cArea.text.trim(),
                  cAreaCode.text.trim(),
                );
                Navigator.pop(context);
              } else {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorAlertDialog(
                        message: "Please fill up all information!",
                      );
                    });
              }
            },
          ),
        ),
      ),
      body: addAddressBody(),
    );
  }

  SingleChildScrollView addAddressBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  MyTextFormField(
                    maxLine: 1,
                    controller: cName,
                    hintText: "Enter your Full Name",
                    labelText: "Name",
                  ),
                  MyTextFormField(
                    maxLine: 1,
                    controller: cPhoneNumber,
                    hintText: "Enter your Phone Number",
                    labelText: "Phone Number",
                  ),
                  MyTextFormField(
                    maxLine: 1,
                    controller: cCity,
                    hintText: "Enter your City Name",
                    labelText: "City",
                  ),
                  MyTextFormField(
                    maxLine: 2,
                    controller: cArea,
                    hintText: "Enter your Area Name",
                    labelText: "Area",
                  ),
                  MyTextFormField(
                    maxLine: 3,
                    controller: cHouseandRoadNumber,
                    hintText: "Enter your House & Road No",
                    labelText: "Flat and Road",
                  ),
                  MyTextFormField(
                    maxLine: 1,
                    controller: cAreaCode,
                    hintText: "Enter your Area Code",
                    labelText: "Area Code",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
