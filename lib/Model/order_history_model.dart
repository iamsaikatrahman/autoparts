class OrderHistoyModel {
  String orderHistoyId;
  String productId;
  String pImage;
  String pName;
  int orginalPrice;
  int newPrice;
  int quantity;
  OrderHistoyModel({
    this.orderHistoyId,
    this.pImage,
    this.productId,
    this.pName,
    this.orginalPrice,
    this.newPrice,
    this.quantity,
  });
  OrderHistoyModel.fromJson(Map<String, dynamic> json) {
    orderHistoyId = json['orderHistoyId'];
    productId = json['productId'];
    pImage = json['pImage'];
    pName = json['pName'];
    orginalPrice = json['orginalPrice'];
    newPrice = json['newPrice'];
    quantity = json['quantity'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderHistoyId'] = this.orderHistoyId;
    data['productId'] = this.productId;
    data['pImage'] = this.pImage;
    data['pName'] = this.pName;
    data['orginalPrice'] = this.orginalPrice;
    data['newPrice'] = this.newPrice;
    data['quantity'] = this.quantity;
    return data;
  }
}
