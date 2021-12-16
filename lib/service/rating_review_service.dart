import 'package:autoparts/config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingAndReviewService {
  addRatingandReviewForuser(
      String userAvatar,
      String userName,
      String userId,
      String productId,
      String productName,
      String productImage,
      int rating,
      String reviewMessage) {
    final data = FirebaseFirestore.instance
        .collection(AutoParts.collectionUser)
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .collection('ratingandreviews');

    data.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "userAvatar": userAvatar,
      "userName": userName,
      "userId": userId,
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "rating": rating,
      "reviewMessage": reviewMessage,
      "publishedDate": DateTime.now(),
    }).whenComplete(() {
      addRatingandReviewForglobal(userAvatar, userName, userId, productId,
          productName, productImage, rating, reviewMessage);
    });
  }

  addRatingandReviewForglobal(
      String userAvatar,
      String userName,
      String userId,
      String productId,
      String productName,
      String productImage,
      int rating,
      String reviewMessage) {
    final data = FirebaseFirestore.instance.collection('ratingandreviews');
    data.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "userAvatar": userAvatar,
      "userName": userName,
      "userId": userId,
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "rating": rating,
      "reviewMessage": reviewMessage,
      "publishedDate": DateTime.now(),
    });
  }
}
