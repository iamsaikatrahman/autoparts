import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String productId;
  String cartId;
  String shortInfo;
  String productName;
  String categoryName;
  String brandName;
  Timestamp publishedDate;
  String description;
  int newprice;
  int orginalprice;
  int offervalue;
  String status;
  String productImgUrl;

  ProductModel({
    this.productId,
    this.cartId,
    this.shortInfo,
    this.productName,
    this.categoryName,
    this.brandName,
    this.publishedDate,
    this.description,
    this.newprice,
    this.orginalprice,
    this.offervalue,
    this.status,
    this.productImgUrl,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    cartId = json['cartId'];
    shortInfo = json['shortInfo'];
    productName = json['productName'];
    categoryName = json['categoryName'];
    brandName = json['brandName'];
    publishedDate = json['publishedDate'];
    description = json['description'];
    newprice = json['newprice'];
    orginalprice = json['orginalprice'];
    offervalue = json['offer'];
    status = json['status'];
    productImgUrl = json['productImgUrl'];
  }
  ProductModel.fromSnaphot(DocumentSnapshot snapshot) {
    productId = snapshot.data()['productId'];
    cartId = snapshot.data()['cartId'];
    shortInfo = snapshot.data()['shortInfo'];
    productName = snapshot.data()['productName'];
    categoryName = snapshot.data()['categoryName'];
    brandName = snapshot.data()['brandName'];
    publishedDate = snapshot.data()['publishedDate'];
    description = snapshot.data()['description'];
    newprice = snapshot.data()['newprice'];
    orginalprice = snapshot.data()['orginalprice'];
    offervalue = snapshot.data()['offer'];
    status = snapshot.data()['status'];
    productImgUrl = snapshot.data()['productImgUrl'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['cartId'] = this.cartId;
    data['shortInfo'] = this.shortInfo;
    data['productName'] = this.productName;
    data['categoryName'] = this.categoryName;
    data['brandName'] = this.brandName;
    data['publishedDate'] = this.publishedDate;
    data['description'] = this.description;
    data['newprice'] = this.newprice;
    data['orginalprice'] = this.orginalprice;
    data['offer'] = this.offervalue;
    data['status'] = this.status;
    data['productImgUrl'] = this.productImgUrl;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
