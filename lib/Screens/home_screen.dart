import 'package:autoparts/Helper/home_helper.dart';
import 'package:autoparts/widgets/mycustom_appbar.dart';
import 'package:autoparts/widgets/mycustomdrawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: MyCustomAppBar(),
        drawer: MyCustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHelper().homeCarousel(context),
              HomeHelper().categoriesCard(context),
              HomeHelper().uptoFiftyPercentOFFCard(),
              HomeHelper().newArrivalCard(),
              HomeHelper().vacuumsCard(),
              HomeHelper().helmetCard(),
              HomeHelper().airfresnersCard(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit!'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              SizedBox(height: 16),
            ],
          ),
        ) ??
        false;
  }
}
