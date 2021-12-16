import 'package:autoparts/Screens/orders/myOrder_details_secreen.dart';
import 'package:autoparts/Screens/orders/myservice_order_screen.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/emptycardmessage.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final f = new DateFormat('dd-MM-yyyy');
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
          "My Orders",
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
            icon: Image.asset(
              "assets/icons/service.png",
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MyServiceOrderScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(AutoParts.collectionUser)
                  .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
                  .collection(AutoParts.collectionOrders)
                  .orderBy("orderTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }

                return (snapshot.data.docs.length == 0)
                    ? EmptyCardMessage(
                        listTitle: "No Order!",
                        message: "Start Shopping from AutoParts!",
                      )
                    : OrderBody(
                        itemCount: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderBody extends StatelessWidget {
  const OrderBody({
    @required this.itemCount,
    @required this.data,
    Key key,
  }) : super(key: key);
  final int itemCount;
  final List data;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          DateTime myDateTime = (data[index].data()['orderTime']).toDate();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Order ID: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            TextSpan(
                              text: data[index].data()['orderId'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "(" +
                            (data[index].data()[AutoParts.productID].length - 1)
                                .toString() +
                            " items)",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Total Price: " +
                            data[index].data()['totalPrice'].toString() +
                            " TK.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(DateFormat.yMMMd().add_jm().format(myDateTime)),
                      Text(timeago
                          .format(DateTime.tryParse(data[index]
                              .data()['orderTime']
                              .toDate()
                              .toString()))
                          .toString()),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MyOrderDetailsScreen(
                                orderId: data[index].data()['orderId'],
                                addressId: data[index].data()['addressID'],
                              ),
                            ),
                          );
                        },
                        color: Colors.deepOrangeAccent[200],
                        child: Text(
                          "Order Details",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 10,
                width: double.infinity,
                color: Colors.blueGrey[50],
              ),
            ],
          );
        },
      ),
    );
  }
}
