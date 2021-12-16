import 'package:autoparts/Helper/login_helper.dart';
import 'package:autoparts/config/config.dart';
import 'package:autoparts/widgets/customTextField.dart';
import 'package:autoparts/widgets/progressdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autoparts/Screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:autoparts/widgets/erroralertdialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  String userloginemail;
  String userloginpassword;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              LoginHelper().loginLog(),
              LoginHelper().welcomeText(),
              SizedBox(height: 10),
              LoginHelper().subtitleText(),
              SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailTextEditingController,
                      textInputType: TextInputType.emailAddress,
                      data: Icons.email_outlined,
                      hintText: "Email",
                      labelText: "Email",
                      isObsecure: false,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      controller: _passwordTextEditingController,
                      textInputType: TextInputType.text,
                      data: Icons.lock_outline,
                      hintText: "Password",
                      labelText: "Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Login",
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
                    userloginemail = _emailTextEditingController.text;
                    userloginpassword = _passwordTextEditingController.text;
                    if (!userloginemail.contains("@")) {
                      showSnackBar("Please provide a valid email address");
                      return;
                    }

                    if (userloginpassword.length < 8) {
                      showSnackBar("Password must be at least 8 characters");
                      return;
                    }
                    final email = userloginemail.trim();
                    final password = userloginpassword.trim();
                    loginUser(email, password, context);
                  },
                ),
              ),
              SizedBox(height: 10),
              LoginHelper().orText(),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.orangeAccent,
                  ),
                  label: Text(
                    " Continue with Google",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    googleaccountSignIn(context);
                  },
                ),
              ),
              SizedBox(height: 15),
              LoginHelper().divider(context),
              SizedBox(height: 15),
              LoginHelper().donthaveaccount(context),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

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

  Future loginUser(String email, String password, BuildContext context) async {
    //------show please wait dialog----------//
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: "Login, Please wait....",
      ),
    );

    User fUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      fUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (fUser != null) {
      readEmailSignInUserData(fUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readEmailSignInUserData(User fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await AutoParts.sharedPreferences
          .setString("uid", dataSnapshot.data()[AutoParts.userUID]);
      await AutoParts.sharedPreferences.setString(
          AutoParts.userEmail, dataSnapshot.data()[AutoParts.userEmail]);
      await AutoParts.sharedPreferences.setString(
          AutoParts.userName, dataSnapshot.data()[AutoParts.userName]);
      await AutoParts.sharedPreferences.setString(AutoParts.userAvatarUrl,
          dataSnapshot.data()[AutoParts.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data()[AutoParts.userCartList].cast<String>();
      await AutoParts.sharedPreferences
          .setStringList(AutoParts.userCartList, cartList);
    });
  }

  Future<bool> googleaccountSignIn(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: "Login, Please wait....",
      ),
    );
    User currentUser;
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User user = userCredential.user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      currentUser = await _auth.currentUser;
      final User googlecurrentuser = _auth.currentUser;
      assert(googlecurrentuser.uid == currentUser.uid);
      if (googlecurrentuser != null) {
        saveUserGoogleSignInInfoToFirebase(googlecurrentuser).whenComplete(() {
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => HomeScreen(),
              ),
            );
          });
        });
      }
    }
    return Future.value(true);
  }

  Future saveUserGoogleSignInInfoToFirebase(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": currentUser.displayName,
      "phone": 'Update your phone..',
      "address": 'Update your address..',
      "url": currentUser.photoURL,
      AutoParts.userCartList: ["garbageValue"],
    });
    await AutoParts.sharedPreferences.setString("uid", currentUser.uid);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userEmail, currentUser.email);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userName, currentUser.displayName);
    await AutoParts.sharedPreferences
        .setString(AutoParts.userPhone, 'Update your phone..');
    await AutoParts.sharedPreferences
        .setString(AutoParts.userAddress, 'Update your address..');
    await AutoParts.sharedPreferences
        .setString(AutoParts.userAvatarUrl, currentUser.photoURL);
    await AutoParts.sharedPreferences
        .setStringList(AutoParts.userCartList, ["garbageValue"]);
  }
}
