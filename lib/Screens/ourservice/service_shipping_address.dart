import 'package:autoparts/Model/addresss.dart';
import 'package:autoparts/Screens/Address/addAddress.dart';
import 'package:autoparts/Screens/ourservice/service_payment.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/changeAddress.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:autoparts/widgets/widebutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceShippingAddress extends StatefulWidget {
  final int totalPrice;

  const ServiceShippingAddress({
    Key key,
    this.totalPrice,
  }) : super(key: key);
  @override
  _ServiceShippingAddressState createState() => _ServiceShippingAddressState();
}

class _ServiceShippingAddressState extends State<ServiceShippingAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "AutoParts",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: "Brand-Regular",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_location),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => AddAddress());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
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
                  "Select Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Consumer<AddressChange>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: AutoParts.firestore
                      .collection(AutoParts.collectionUser)
                      .doc(AutoParts.sharedPreferences
                          .getString(AutoParts.userUID))
                      .collection(AutoParts.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: circularProgress())
                        : snapshot.data.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressId: snapshot.data.docs[index].id,
                                    totalPrice: widget.totalPrice,
                                    model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data()),
                                  );
                                },
                              );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.blueGrey.withOpacity(0.5),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white),
            Text("No shipment address has been saved"),
            Text(
              "Please add your shipment address so we can deliver your product.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;

  final String addressId;
  final int totalPrice;
  final int currentIndex;
  final int value;
  const AddressCard({
    Key key,
    this.model,
    this.addressId,
    this.totalPrice,
    this.currentIndex,
    this.value,
  }) : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChange>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.white.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  activeColor: Colors.deepOrangeAccent,
                  onChanged: (val) {
                    Provider.of<AddressChange>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name"),
                              Text(widget.model.customerName),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Phone Number"),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "House & Road No"),
                              Text(widget.model.houseandroadno),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "City"),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Area"),
                              Text(widget.model.area),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Area Code"),
                              Text(widget.model.areacode),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChange>(context).count
                ? WideButton(
                    message: "Proceed",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (_) => ServicePaymentPage(
                          addressId: widget.addressId,
                          totalPrice: widget.totalPrice,
                        ),
                      );
                      Navigator.push(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
