import 'package:cloud_firestore/cloud_firestore.dart';

class RatingAndReviewModel {
  String userAvatar;
  String userName;
  Timestamp publishedDate;
  String reviewMessage;
  String productId;
  String productName;
  String productImage;
  String userId;
  int rating;
  RatingAndReviewModel({
    this.userAvatar,
    this.userName,
    this.publishedDate,
    this.reviewMessage,
    this.productId,
    this.productName,
    this.productImage,
    this.userId,
    this.rating,
  });

  RatingAndReviewModel.formJson(Map<String, dynamic> json) {
    userAvatar = json['userAvatar'];
    userName = json['userName'];
    publishedDate = json['publishedDate'];
    reviewMessage = json['reviewMessage'];
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    userId = json['userId'];
    rating = json['rating'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAvatar'] = this.userAvatar;
    data['userName'] = this.userName;
    data['publishedDate'] = this.publishedDate;
    data['reviewMessage'] = this.reviewMessage;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productImage'] = this.productImage;
    data['userId'] = this.userId;
    data['rating'] = this.rating;
    return data;
  }
}
