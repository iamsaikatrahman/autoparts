import 'package:autoparts/Helper/drawer_helper.dart';
import 'package:autoparts/Screens/about_Screen.dart';
import 'package:autoparts/Screens/cart_screen.dart';
import 'package:autoparts/Screens/home_screen.dart';
import 'package:autoparts/Screens/myaccount_screen.dart';
import 'package:autoparts/Screens/myreview_rating_screen.dart';
import 'package:autoparts/Screens/orders/myOrder_Screen.dart';
import 'package:autoparts/Screens/ourservice/our_service_screen.dart';
import 'package:autoparts/Screens/splash_screen.dart';
import 'package:autoparts/Screens/wishlist_screen.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/noInternetConnectionAlertDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class MyCustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.orange],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    elevation: 8.0,
                    child: Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          AutoParts.sharedPreferences
                              .getString(AutoParts.userAvatarUrl),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    AutoParts.sharedPreferences.getString(AutoParts.userName),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AutoParts.sharedPreferences.getString(AutoParts.userEmail),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  DrawerItems(
                    leadingIcon: Icons.home_outlined,
                    title: "Home",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => HomeScreen());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.person_outline_outlined,
                    title: "My Account",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => MyAccountScreen());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NoInternetConnectionAlertDialog();
                            });
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => MyOrderScreen());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.shopping_cart_outlined,
                    title: "My Carts",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => CartScreen());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.favorite_border_outlined,
                    title: "My WishLits",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => WishListScreen());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.calendar_today_outlined,
                    title: "Our Service",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => OurService());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.message_outlined,
                    title: "My Rating & Reviews",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route = MaterialPageRoute(
                          builder: (_) => MyReviewAndRating());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.settings,
                    title: "About",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NoInternetConnectionAlertDialog();
                          },
                        );
                      }
                      Route route =
                          MaterialPageRoute(builder: (_) => AboutScreen());
                      Navigator.push(context, route);
                    },
                  ),
                  DrawerDivider(),
                  DrawerItems(
                    leadingIcon: Icons.exit_to_app,
                    title: "Logout",
                    traillingIcon: Icons.keyboard_arrow_right,
                    onPressed: () {
                      AutoParts.auth.signOut().then((c) {
                        Route route =
                            MaterialPageRoute(builder: (_) => SplashScreen());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                  DrawerDivider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
