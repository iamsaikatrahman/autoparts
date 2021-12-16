class WishModel {
  String wishId;
  String productId;
  String pImage;
  String pName;
  String pBrand;
  int newPrice;
  WishModel({
    this.wishId,
    this.pImage,
    this.productId,
    this.pName,
    this.pBrand,
    this.newPrice,
  });
  WishModel.fromJson(Map<String, dynamic> json) {
    wishId = json['wishId'];
    productId = json['productId'];
    pImage = json['pImage'];
    pName = json['pName'];
    pBrand = json['pBrand'];
    newPrice = json['newPrice'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wishId'] = this.wishId;
    data['productId'] = this.productId;
    data['pImage'] = this.pImage;
    data['pName'] = this.pName;
    data['pBrand'] = this.pBrand;
    data['newPrice'] = this.newPrice;
    return data;
  }
}
