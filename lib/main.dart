import 'package:autoparts/Helper/login_helper.dart';
import 'package:autoparts/Screens/splash_screen.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/counter/changeAddress.dart';
import 'package:autoparts/counter/service_item_counter.dart';
import 'package:autoparts/counter/service_total_money.dart';
import 'package:autoparts/counter/wishlist_item_count.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autoparts/counter/cart_item_counter.dart';
import 'package:autoparts/counter/total_money.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AutoParts.auth = FirebaseAuth.instance;
  AutoParts.sharedPreferences = await SharedPreferences.getInstance();
  AutoParts.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => LoginHelper()),
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => WishListItemCounter()),
        ChangeNotifierProvider(create: (c) => ServiceItemCounter()),
        ChangeNotifierProvider(create: (c) => AddressChange()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => ServiceTotalPrice()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AutoParts',
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
