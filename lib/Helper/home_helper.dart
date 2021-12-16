import 'package:autoparts/service/category_data.dart';
import 'package:autoparts/widgets/category_tile.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:autoparts/widgets/verticalCard.dart';
import 'package:autoparts/widgets/horizontalCard.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeHelper {
  final _db = FirebaseFirestore.instance.collection('products');
  List<String> imageslider = [];
  Widget categoriesCard(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Brand-Bold",
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryTile(
                  categoryName: categories[index].categoryName,
                  imageUrl: categories[index].imageUrl,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget homeCarousel(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Carousels")
          .orderBy("publishedDate", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<String> sliderImage = [];
        for (int i = 0; i < snapshot.data.docs.length; i++) {
          DocumentSnapshot snap = snapshot.data.docs[i];
          sliderImage.add(
            snap.data()["carouselImgUrl"],
          );
        }
        return Container(
          height: 200,
          width: double.infinity,
          child: Carousel(
            boxFit: BoxFit.cover,
            indicatorBgPadding: 8,
            dotSize: 4,
            images: sliderImage
                .map(
                  (e) => Container(
                    child: Image.network(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget uptoFiftyPercentOFFCard() {
    return VerticalCard(
      cardTitle: 'Up to 50% off',
      stream: _db.where("offer", isGreaterThanOrEqualTo: 50).snapshots(),
    );
  }

  Widget newArrivalCard() {
    return VerticalCard(
      cardTitle: 'New Arrival',
      stream: _db.orderBy('publishedDate', descending: true).snapshots(),
    );
  }

  Widget vacuumsCard() {
    return HorizontalCard(
      cardTitle: 'Vacuums',
      stream: _db.where("categoryName", isEqualTo: 'Vacuums').snapshots(),
    );
  }

  Widget helmetCard() {
    return VerticalCard(
      cardTitle: 'Helmet',
      stream: _db.where("categoryName", isEqualTo: 'Helmet').snapshots(),
    );
  }
  Widget airfresnersCard() {
    return HorizontalCard(
      cardTitle: 'Air Fresheners',
      stream: _db.where("categoryName", isEqualTo: 'Air Fresheners').snapshots(),
    );
  }
}
