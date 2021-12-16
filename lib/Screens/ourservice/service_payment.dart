import 'dart:async';

import 'package:autoparts/Screens/home_screen.dart';
import 'package:autoparts/Screens/ourservice/backend_orderservice.dart';

import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/confirm_animation_button.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServicePaymentPage extends StatefulWidget {
  final String addressId;
  final int totalPrice;
  const ServicePaymentPage({
    Key key,
    this.addressId,
    this.totalPrice,
  }) : super(key: key);
  @override
  _ServicePaymentPageState createState() => _ServicePaymentPageState();
}

class _ServicePaymentPageState extends State<ServicePaymentPage> {
  String orderId = DateTime.now().microsecondsSinceEpoch.toString();
  bool isTap = false;
  bool goHome = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(false, "Payment Method"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Choose Payment Method",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(AutoParts.collectionUser)
                    .doc(AutoParts.sharedPreferences
                        .getString(AutoParts.userUID))
                    .collection('ServiceCart')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Column(
                    children: [
                      PaymentButton(
                        onTap: () async {
                          setState(() {
                            isTap = true;
                          });
                        },
                        leadingImage: "assets/icons/cod.png",
                        title: "Cash on Delivery",
                      ),
                      (isTap)
                          ? AnimatedConfirmButton(
                              onTap: () {
                                for (int i = 0;
                                    i < snapshot.data.docs.length;
                                    i++) {
                                  BackEndOrderService()
                                      .writeServiceOrderDetailsForUser(
                                    orderId,
                                    widget.addressId,
                                    widget.totalPrice,
                                    "Cash on Delivery",
                                    snapshot.data.docs[i].data()['serviceId'],
                                    snapshot.data.docs[i].data()['serviceName'],
                                    snapshot.data.docs[i].data()['date'],
                                    snapshot.data.docs[i]
                                        .data()['serviceImage'],
                                    snapshot.data.docs[i]
                                        .data()['orginalPrice'],
                                    snapshot.data.docs[i].data()['newPrice'],
                                    snapshot.data.docs[i].data()['quantity'],
                                    context,
                                  );
                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      isTap = false;
                                      goHome = true;
                                    });
                                  });
                                }
                              },
                              animationDuration:
                                  const Duration(milliseconds: 2000),
                              initialText: "Confirm",
                              finalText: "Order Done",
                              iconData: Icons.check,
                              iconSize: 32.0,
                              buttonStyle: ConfirmButtonStyle(
                                primaryColor: Colors.green.shade600,
                                secondaryColor: Colors.white,
                                elevation: 20.0,
                                initialTextStyle: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                                finalTextStyle: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.green.shade600,
                                ),
                                borderRadius: 10.0,
                              ),
                            )
                          : Container(),
                      (goHome)
                          ? Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    offset: Offset(1, 3),
                                    blurRadius: 6,
                                    spreadRadius: -3,
                                  ),
                                ],
                              ),
                              child: RaisedButton.icon(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.deepOrangeAccent[200],
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                  setState(() {
                                    goHome = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.home_outlined,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Go Home",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                }),
            PaymentButton(
              onTap: () {},
              leadingImage: "assets/icons/online_payment.png",
              title: "Online Payment",
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    Key key,
    @required this.onTap,
    @required this.leadingImage,
    @required this.title,
  }) : super(key: key);
  final Function onTap;
  final String leadingImage;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
          child: ListTile(
            leading: Image.asset(
              leadingImage,
              width: 40,
              height: 40,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                fontFamily: "Brand-Regular",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
