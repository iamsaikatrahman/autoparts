import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/loading_widget.dart';
import 'package:autoparts/widgets/mycustomdrawer.dart';
import 'package:autoparts/widgets/mytextFormfield.dart';
import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // @override
  // void initState() {
  //   nameController.text =
  //       AutoParts.sharedPreferences.getString(AutoParts.userName);
  //   phoneController.text =
  //       AutoParts.sharedPreferences.getString(AutoParts.userPhone);
  //   addressController.text =
  //       AutoParts.sharedPreferences.getString(AutoParts.userAddress);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: simpleAppBar(false, 'My Account'),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 40,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("uid",
                        isEqualTo: AutoParts.sharedPreferences
                            .getString(AutoParts.userUID))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return RaisedButton(
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          nameController.text =
                              snapshot.data.docs[i].data()['name'];
                          phoneController.text =
                              snapshot.data.docs[i].data()['phone'];
                          addressController.text =
                              snapshot.data.docs[i].data()['address'];
                        }
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                "Update Profile",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    updateUserProfileInfo().whenComplete(() {
                                      setState(() {});
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text('Submit'),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text('Cancel'),
                                ),
                              ],
                              content: SingleChildScrollView(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MyTextFormField(
                                        controller: nameController,
                                        hintText: "Enter your full name",
                                        labelText: 'Name',
                                        maxLine: 1,
                                      ),
                                      MyTextFormField(
                                        controller: phoneController,
                                        hintText: "Enter your phone number",
                                        labelText: 'Phone',
                                        maxLine: 1,
                                      ),
                                      MyTextFormField(
                                        controller: addressController,
                                        hintText: "Enter your address",
                                        labelText: 'Address',
                                        maxLine: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Brand-Bold",
                        letterSpacing: 1.5,
                        fontSize: 18,
                      ),
                    ),
                  );
                }),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("uid",
                        isEqualTo: AutoParts.sharedPreferences
                            .getString(AutoParts.userUID))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return circularProgress();
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              elevation: 5.0,
                              child: Container(
                                width: 140,
                                height: 140,
                                child: CircleAvatar(
                                  radius: size.width * 0.15,
                                  backgroundColor: Colors.deepOrange,
                                  backgroundImage: NetworkImage(
                                    snapshot.data.docs[index].data()['url'],
                                  ),
                                  // backgroundImage: NetworkImage(
                                  //   AutoParts.sharedPreferences
                                  //       .getString(AutoParts.userAvatarUrl),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  ProfileText(
                                    title: "Name: ",
                                    informationtext: snapshot.data.docs[index]
                                        .data()['name'],
                                    // informationtext: AutoParts.sharedPreferences
                                    //     .getString(AutoParts.userName),
                                  ),
                                  SizedBox(height: 5),
                                  ProfileText(
                                    title: "Email: ",
                                    informationtext: snapshot.data.docs[index]
                                        .data()['email'],
                                    // informationtext: AutoParts.sharedPreferences
                                    //     .getString(AutoParts.userEmail),
                                  ),
                                  SizedBox(height: 5),
                                  ProfileText(
                                    title: "Phone: ",
                                    informationtext: snapshot.data.docs[index]
                                        .data()['phone'],
                                    // informationtext: AutoParts.sharedPreferences
                                    //     .getString(AutoParts.userPhone),
                                  ),
                                  SizedBox(height: 5),
                                  ProfileText(
                                    title: "Address: ",
                                    informationtext: snapshot.data.docs[index]
                                        .data()['address'],
                                    // informationtext: AutoParts.sharedPreferences
                                    //     .getString(AutoParts.userAddress),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future updateUserProfileInfo() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(AutoParts.sharedPreferences.getString(AutoParts.userUID))
        .update({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "address": addressController.text.trim(),
    });
    await AutoParts.sharedPreferences
        .setString(AutoParts.userName, nameController.text);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userPhone, phoneController.text);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userAddress, addressController.text);
  }
}

class ProfileText extends StatelessWidget {
  final String title;
  final String informationtext;

  const ProfileText({
    Key key,
    this.title,
    this.informationtext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 22,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: informationtext,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Brand-Regular",
            ),
          ),
        ],
      ),
    );
  }
}
