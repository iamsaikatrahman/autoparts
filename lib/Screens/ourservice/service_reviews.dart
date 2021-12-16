import 'package:autoparts/Model/rating_review_model.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceReviews extends StatefulWidget {
  final String serviceId;

  const ServiceReviews({
    Key key,
    this.serviceId,
  }) : super(key: key);
  @override
  _ServiceReviewsState createState() => _ServiceReviewsState();
}

class _ServiceReviewsState extends State<ServiceReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        false,
        "Rating & Reviews",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ratingandreviews')
            .where("productId", isEqualTo: widget.serviceId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return (snapshot.data.docs.length == 0)
              ? Container()
              : SingleChildScrollView(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        RatingAndReviewModel ratingAndReviewModel =
                            RatingAndReviewModel.formJson(
                          snapshot.data.docs[index].data(),
                        );
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              ratingAndReviewModel.userAvatar,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ratingAndReviewModel.userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Brand-Regular",
                                ),
                              ),
                              Row(
                                children: [
                                  Text('${ratingAndReviewModel.rating}'),
                                  for (int i = 0;
                                      i < ratingAndReviewModel.rating;
                                      i++)
                                    Text('⭐'),
                                ],
                              )
                            ],
                          ),
                          subtitle: Text(ratingAndReviewModel.reviewMessage),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
