import 'package:autoparts/Model/product_model.dart';
import 'package:autoparts/Screens/products/product_details.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/service/cart_service.dart';
import 'package:autoparts/service/wishlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final searchProductController = TextEditingController();

  List _allProductResults = [];
  List _productResultList = [];
  Future productResultsLoaded;
  @override
  void initState() {
    searchProductController.addListener(_onProductSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchProductController.removeListener(_onProductSearchChanged);
    searchProductController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productResultsLoaded = getAllSearchProductsData();
  }

  _onProductSearchChanged() {
    searchProductsResultsList();
  }

  searchProductsResultsList() {
    var showResult = [];
    if (searchProductController.text != "") {
      for (var productfromjson in _allProductResults) {
        var productName =
            ProductModel.fromSnaphot(productfromjson).productName.toLowerCase();
        if (productName.contains(searchProductController.text.toLowerCase())) {
          showResult.add(productfromjson);
        }
      }
    } else {
      showResult = List.from(_allProductResults);
    }
    _productResultList = showResult;
  }

  getAllSearchProductsData() async {
    var data = await FirebaseFirestore.instance
        .collection('products')
        .orderBy("publishedDate", descending: true)
        .get();
    setState(() {
      _allProductResults = data.docs;
    });
    searchProductsResultsList();
    return "Complete";
  }

  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (searchProductController) {
            setState(() {
              searchProductController;
            });
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          controller: searchProductController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 0,
            ),
            hintText: 'Search products...',
            hintStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              searchProductController.text = "";
            },
          ),
        ],
      ),
      body: SearchProductGridCard(
        productResultList: _productResultList,
        quantity: quantity,
      ),
    );
  }
}

class SearchProductGridCard extends StatelessWidget {
  const SearchProductGridCard({
    Key key,
    @required List productResultList,
    @required this.quantity,
  })  : _productResultList = productResultList,
        super(key: key);

  final List _productResultList;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _productResultList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext context, int index) {
            ProductModel productModel =
                ProductModel.fromSnaphot(_productResultList[index]);
            return GestureDetector(
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (c) => ProductDetails(
                          productModel: productModel,
                        ));
                Navigator.push(context, route);
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            productModel.productImgUrl,
                            width: 150,
                            height: 100,
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productModel.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.branding_watermark_outlined),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        productModel.brandName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Brand-Regular",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (productModel.offervalue < 1)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "\৳${productModel.orginalprice}",
                                          style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            fontSize: 16,
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\৳${productModel.newprice}",
                                            style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              fontSize: 16,
                                              color: Colors.deepOrangeAccent,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\৳${productModel.orginalprice}",
                                                style: TextStyle(
                                                  fontFamily: "Brand-Regular",
                                                  fontSize: 16,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '- ${productModel.offervalue}%',
                                                style: TextStyle(
                                                  fontFamily: "Brand-Regular",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            spreadRadius: -2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(AutoParts.collectionUser)
                              .doc(AutoParts.sharedPreferences
                                  .getString(AutoParts.userUID))
                              .collection('wishLists')
                              .where("productId",
                                  isEqualTo: productModel.productId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return Center(
                              child: IconButton(
                                icon: (snapshot.data.docs.length == 1)
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.deepOrangeAccent,
                                      )
                                    : Icon(
                                        Icons.favorite_border_rounded,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                onPressed: () {
                                  WishListService().addWish(
                                    productModel.productId,
                                    productModel.productName,
                                    productModel.brandName,
                                    productModel.productImgUrl,
                                    productModel.newprice,
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Item Added to WishList Successfully.",
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(AutoParts.collectionUser)
                              .doc(AutoParts.sharedPreferences
                                  .getString(AutoParts.userUID))
                              .collection('carts')
                              .where("productId",
                                  isEqualTo: productModel.productId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return IconButton(
                              icon: (snapshot.data.docs.length == 1)
                                  ? Icon(
                                      Icons.shopping_bag,
                                      size: 25,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.add_shopping_cart_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                              onPressed: () {
                                CartService().checkItemInCart(
                                  productModel.productId,
                                  productModel.productName,
                                  productModel.productImgUrl,
                                  productModel.newprice,
                                  productModel.newprice =
                                      productModel.newprice * quantity,
                                  quantity,
                                  context,
                                );
                              },
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
