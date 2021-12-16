import 'dart:io';
import 'dart:async';
import 'package:autoparts/Screens/Authentication/login_screen.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/customTextField.dart';
import 'package:autoparts/widgets/progressdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autoparts/Screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autoparts/widgets/erroralertdialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _cpasswordTextEditingController = TextEditingController();
  String userImage = "";
  File avatarImageFile;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        avatarImageFile = image;
      });
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Text(
                "Let\'s Get Started!",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Brand-Bold',
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Create an account to AutoParts to get all features",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Brand-Regular',
                    letterSpacing: 1,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 130,
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: Colors.deepOrange,
                    backgroundImage: (avatarImageFile != null)
                        ? FileImage(avatarImageFile)
                        : AssetImage("assets/authenticaiton/user_icon.png"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameTextEditingController,
                      textInputType: TextInputType.text,
                      data: Icons.account_circle,
                      hintText: "Full Name",
                      labelText: "Full Name",
                      isObsecure: false,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailTextEditingController,
                      textInputType: TextInputType.emailAddress,
                      data: Icons.email_outlined,
                      hintText: "Email",
                      labelText: "Email",
                      isObsecure: false,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      textInputType: TextInputType.text,
                      data: Icons.lock_outline,
                      hintText: "Password",
                      labelText: "Password",
                      isObsecure: true,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _cpasswordTextEditingController,
                      textInputType: TextInputType.text,
                      data: Icons.lock_outline,
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              //--------------------Create Button-----------------------//
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Create".toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    //-------------Internet Connectivity--------------------//
                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar("No internet connectivity");
                      return;
                    }
                    //----------------checking textfield--------------------//
                    if (_nameTextEditingController.text.length < 4) {
                      showSnackBar("Name must be at least 4 characters");
                      return;
                    }
                    if (!_emailTextEditingController.text.contains("@")) {
                      showSnackBar("Please provide a valid email address");
                      return;
                    }

                    if (_passwordTextEditingController.text.length < 8) {
                      showSnackBar("Password must be at least 8 characters");
                      return;
                    }
                    if (_passwordTextEditingController.text !=
                        _cpasswordTextEditingController.text) {
                      showSnackBar("Confirm Password is not match");
                      return;
                    }
                    uploadAndSaveImage();
                  },
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  height: 2.0,
                  width: size.width / 2 - 30,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account ?',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (c) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      ' Login here',
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

//--------------custom snackbar----------------------//
  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  Future<void> uploadAndSaveImage() async {
    if (avatarImageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "Please Select an image",
          );
        },
      );
    } else {
      uploadToStorage();
    }
  }

  uploadToStorage() async {
    //------show please wait dialog----------//
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: "Registering, Please wait....",
      ),
    );
    String imgeFileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(imgeFileName);
    UploadTask uploadTask = reference.putFile(avatarImageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((urlImage) => userImage = urlImage);
      createUser();
    });
  }

//----------------------create user-----------------------//
  Future createUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
          email: _emailTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim(),
        )
        .then((auth) => firebaseUser = auth.user)
        .catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, route);
      });
    }
  }

//--------------------save user information to firestore-----------------//
  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "phone": 'Update your phone..',
      "address": 'Update your address..',
      "url": userImage,
      AutoParts.userCartList: ["garbageValue"],
    });
    await AutoParts.sharedPreferences.setString("uid", fUser.uid);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userEmail, fUser.email);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userName, _nameTextEditingController.text);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userPhone, 'Update your phone..');
    await AutoParts.sharedPreferences
        .setString(AutoParts.userAddress, 'Update your address..');
    await AutoParts.sharedPreferences
        .setString(AutoParts.userAvatarUrl, userImage);
    await AutoParts.sharedPreferences
        .setStringList(AutoParts.userCartList, ["garbageValue"]);
  }
}
