import 'package:autoparts/Screens/orders/myservice_order_screen.dart';
import 'package:autoparts/Screens/ourservice/coustomServicebody.dart';
import 'package:flutter/material.dart';

class OurService extends StatefulWidget {
  @override
  _OurServiceState createState() => _OurServiceState();
}

class _OurServiceState extends State<OurService> {
  int selectedIndex = 0;
  double width = 50;
  double height = 30;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.orange],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Our Service",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: "Brand-Regular",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/icons/service.png",
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MyServiceOrderScreen()));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    backgroundColor: Colors.deepOrangeAccent,
                    selectedIndex: selectedIndex,
                    labelType: NavigationRailLabelType.selected,
                    onDestinationSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                        pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    destinations: [
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_wash.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 0)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_repair.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 1)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_maintance.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 2)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_paint.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 3)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_tyre.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 4)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                      NavigationRailDestination(
                        icon: Image.asset(
                          "assets/icons/car_windshield.png",
                          width: width,
                          height: height,
                          color: (selectedIndex == 5)
                              ? Colors.white
                              : Colors.white70,
                        ),
                        label: Text(""),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CoustomServiceBody(
                  isEqualTo: "Car Wash",
                ),
                CoustomServiceBody(
                  isEqualTo: "Car Repair",
                ),
                CoustomServiceBody(
                  isEqualTo: "Car Maintance",
                ),
                CoustomServiceBody(
                  isEqualTo: "Car Denting and Painting",
                ),
                CoustomServiceBody(
                  isEqualTo: "Car Tyre Replacment",
                ),
                CoustomServiceBody(
                  isEqualTo: "Car windshield Replacment",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
