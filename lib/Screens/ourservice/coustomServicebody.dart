import 'dart:async';

import 'package:autoparts/Model/rating_review_model.dart';
import 'package:autoparts/Model/service_model.dart';
import 'package:autoparts/Screens/ourservice/backend_orderservice.dart';
import 'package:autoparts/Screens/ourservice/orderService_screen.dart';
import 'package:autoparts/Screens/ourservice/service_reviews.dart';
import 'package:autoparts/Screens/ourservice/service_shipping_address.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/service/rating_review_service.dart';
import 'package:autoparts/widgets/confirm_animation_button.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';

class CoustomServiceBody extends StatefulWidget {
  final dynamic isEqualTo;

  const CoustomServiceBody({Key key, this.isEqualTo}) : super(key: key);
  @override
  _CoustomServiceBodyState createState() => _CoustomServiceBodyState();
}

class _CoustomServiceBodyState extends State<CoustomServiceBody> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  double totalrating = 0;
  bool istap = false;
  bool isContinue = false;

  int quantity = 1;
  DateTime date;
  TimeOfDay time;
  String getDateText() {
    if (date == null) {
      return DateFormat('MM/dd/yyyy').format(DateTime.now());
    } else {
      return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("service")
                .where("categoryName", isEqualTo: widget.isEqualTo)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  ServiceModel serviceModel = ServiceModel.fromJson(
                    snapshot.data.docs[index].data(),
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(serviceModel.serviceImgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            color: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    serviceModel.serviceName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Start From",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    letterSpacing: 1,
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${serviceModel.newprice} BDT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1,
                                          fontFamily: "Brand-Regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      (serviceModel.offervalue < 1)
                                          ? TextSpan()
                                          : TextSpan(
                                              text:
                                                  ' (OFF ${serviceModel.offervalue}%)',
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontFamily: "Brand-Regular",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //----------------------about title--------------------//
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "About The Service",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),

//------------------------about text---------------------//
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          serviceModel.aboutInfo.replaceAll("\\n", "\n"),
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      //----------------expect title-------------------//
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "What to Expect",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      //----------------------expectText-----------------//
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          serviceModel.expectation.replaceAll("\\n", "\n"),
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  istap = true;
                                });
                              },
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      (istap)
                          ? Card(
                              elevation: 3,
                              child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceModel.serviceName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "How many " +
                                              serviceModel.serviceName +
                                              " service need?",
                                          maxLines: 3,
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: 55,
                                                child: OutlineButton(
                                                  child: Icon(Icons.remove),
                                                  onPressed: () {
                                                    if (quantity > 1) {
                                                      setState(() {
                                                        quantity--;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 30,
                                              ),
                                              child: Text(
                                                quantity.toString(),
                                                style: TextStyle(
                                                  fontFamily: "Brand-Regular",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 55,
                                                child: OutlineButton(
                                                  child: Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      quantity++;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Selecte your Shedule",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FlatButton.icon(
                                              padding: EdgeInsets.zero,
                                              onPressed: () =>
                                                  pickDate(context),
                                              icon: Icon(Icons
                                                  .calendar_today_outlined),
                                              label: Text(getDateText()),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: AnimatedConfirmButton(
                                            onTap: () {
                                              Timer(Duration(seconds: 1), () {
                                                BackEndOrderService()
                                                    .addService(
                                                  serviceModel.serviceId,
                                                  serviceModel.newprice =
                                                      serviceModel.newprice *
                                                          quantity,
                                                  serviceModel.orginalprice,
                                                  serviceModel.serviceImgUrl,
                                                  serviceModel.serviceName,
                                                  getDateText(),
                                                  quantity,
                                                );
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Service is ready for order!");
                                                setState(() {
                                                  isContinue = true;
                                                });
                                              });
                                            },
                                            animationDuration: const Duration(
                                                milliseconds: 2000),
                                            initialText: "Confirm",
                                            finalText: "Done",
                                            iconData: Icons.check,
                                            iconSize: 32.0,
                                            buttonStyle: ConfirmButtonStyle(
                                              primaryColor:
                                                  Colors.green.shade600,
                                              secondaryColor: Colors.white,
                                              elevation: 10.0,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      (isContinue)
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      offset: Offset(1, 3),
                                      blurRadius: 6,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                ),
                                child: RaisedButton.icon(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.deepOrangeAccent[200],
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ServiceShippingAddress(
                                            totalPrice: serviceModel.newprice *
                                                quantity,
                                          ),
                                        ));
                                    setState(() {
                                      istap = false;
                                      isContinue = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.double_arrow_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  label: Text("Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      )),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(AutoParts.collectionUser)
                              .doc(AutoParts.sharedPreferences
                                  .getString(AutoParts.userUID))
                              .collection('ServiceCart')
                              .where("serviceId",
                                  isEqualTo: serviceModel.serviceId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return (snapshot.data.docs.length == 1)
                                ? Center(
                                    child: AnimatedConfirmButton(
                                      onTap: () {
                                        Timer(Duration(seconds: 1), () {
                                          BackEndOrderService().deleteService(
                                              serviceModel.serviceId);
                                          setState(() {
                                            isContinue = false;
                                            istap = false;
                                          });
                                        });
                                      },
                                      animationDuration:
                                          const Duration(milliseconds: 2000),
                                      initialText: "Delete",
                                      finalText: "Service Delete",
                                      iconData: Icons.check,
                                      iconSize: 32.0,
                                      buttonStyle: ConfirmButtonStyle(
                                        primaryColor:
                                            Colors.deepOrangeAccent[200],
                                        secondaryColor: Colors.white,
                                        elevation: 10.0,
                                        initialTextStyle: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                        ),
                                        finalTextStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.deepOrangeAccent[200],
                                        ),
                                        borderRadius: 10.0,
                                      ),
                                    ),
                                  )
                                : Container();
                          }),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rating & Reviews",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Brand-Bold",
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('ratingandreviews')
                                          .where("productId",
                                              isEqualTo: serviceModel.serviceId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        int userrating = 0;
                                        for (int i = 0;
                                            i < snapshot.data.docs.length;
                                            i++) {
                                          userrating = userrating +
                                              snapshot.data.docs[i]
                                                  .data()['rating'];
                                        }

                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (snapshot.data.docs.length ==
                                                          0)
                                                      ? "0.0"
                                                      : "${(userrating / snapshot.data.docs.length).toStringAsFixed(1)}",
                                                  style: TextStyle(
                                                    fontSize: 35,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star_half,
                                                  size: 25,
                                                  color: Colors
                                                      .deepOrangeAccent[200],
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    '${userrating.toString()}/'),
                                                Text(
                                                  "${snapshot.data.docs.length.toString()} Ratings",
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return RatingDialog(
                                            icon: Image.asset(
                                              "assets/authenticaiton/logo.png",
                                              width: 100,
                                              height: 100,
                                            ),
                                            title: "Give Your Rating",
                                            description:
                                                "Tap a star to set your rating. Add more description here if you want.",
                                            onSubmitPressed: (int rating) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    title: Text(
                                                      "Give your Reivews",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Write your valueable feedback for this service. It\'s help us to upgrade our service.",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(height: 4),
                                                        TextFormField(
                                                          maxLines: 3,
                                                          controller:
                                                              reviewController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "write whatever you want!",
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () {
                                                            RatingAndReviewService()
                                                                .addRatingandReviewForuser(
                                                              AutoParts
                                                                  .sharedPreferences
                                                                  .getString(
                                                                      AutoParts
                                                                          .userAvatarUrl),
                                                              AutoParts
                                                                  .sharedPreferences
                                                                  .getString(
                                                                      AutoParts
                                                                          .userName),
                                                              AutoParts
                                                                  .sharedPreferences
                                                                  .getString(
                                                                      AutoParts
                                                                          .userUID),
                                                              serviceModel
                                                                  .serviceId,
                                                              serviceModel
                                                                  .serviceName,
                                                              serviceModel
                                                                  .serviceImgUrl,
                                                              rating,
                                                              reviewController
                                                                  .text,
                                                            );
                                                            setState(() {
                                                              reviewController
                                                                  .text = "";
                                                            });

                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Thank you giving us your valuable rating and review");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Submit",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .deepOrangeAccent,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            submitButton: "Review",
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Give your rating & review...",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('ratingandreviews')
                                  .where("productId",
                                      isEqualTo: serviceModel.serviceId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                return (snapshot.data.docs.length == 0)
                                    ? Container()
                                    : (snapshot.data.docs.length > 5)
                                        ? Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: 5,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  RatingAndReviewModel
                                                      ratingAndReviewModel =
                                                      RatingAndReviewModel
                                                          .formJson(
                                                    snapshot.data.docs[index]
                                                        .data(),
                                                  );
                                                  return ListTile(
                                                    leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.network(
                                                        ratingAndReviewModel
                                                            .userAvatar,
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ratingAndReviewModel
                                                              .userName,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Brand-Regular",
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${ratingAndReviewModel.rating} ',
                                                            ),
                                                            for (int i = 0;
                                                                i <
                                                                    ratingAndReviewModel
                                                                        .rating;
                                                                i++)
                                                              Text('⭐'),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                        ratingAndReviewModel
                                                            .reviewMessage),
                                                  );
                                                },
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ServiceReviews(
                                                          serviceId:
                                                              serviceModel
                                                                  .serviceId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "More Reviews....",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily:
                                                          "Brand-Regular",
                                                      letterSpacing: 0.5,
                                                      color: Colors
                                                              .deepOrangeAccent[
                                                          200],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              RatingAndReviewModel
                                                  ratingAndReviewModel =
                                                  RatingAndReviewModel.formJson(
                                                snapshot.data.docs[index]
                                                    .data(),
                                              );
                                              return ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    ratingAndReviewModel
                                                        .userAvatar,
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ratingAndReviewModel
                                                          .userName,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            "Brand-Regular",
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '${ratingAndReviewModel.rating}'),
                                                        for (int i = 0;
                                                            i <
                                                                ratingAndReviewModel
                                                                    .rating;
                                                            i++)
                                                          Text('⭐'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                subtitle: Text(
                                                    ratingAndReviewModel
                                                        .reviewMessage),
                                              );
                                            },
                                          );
                              },
                            ),
                          ],
                        ),
                      ),

                      //---------------------Note-------------------//
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Note:",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.deepOrangeAccent[200],
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          "The mentioned pricing is estimated service charges which might vary slightly depending on: Vehicle Type, Model, and Service Availability.",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          "Home Service Policy: The home service charge of maximum BDT 300 is applicable if the customer decides not to take the service after the service provider visited the location.",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
