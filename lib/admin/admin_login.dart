import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:it_support/services/auth_exception_handler.dart';
import 'package:it_support/user_screens/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;

  //===> CREATING INSTANCE OF FIREBASE <===
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //===> CREATING AN UNASSIGNED VARIABLES <===
  String email;
  String password;
  User user;
  bool loading = false;
  bool _autoValidate = false;
  String errorMsg = " ";

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    super.dispose();
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING BOTH LOGIN & REGISTER EMAIL #######
   ****************************************************************/
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
        r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'Your Email Address is required';
    if (!regex.hasMatch(value))
      return 'Enter a valid Email Address';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /***********************************************************************
      ######## FOR VALIDATING LOGIN & REGISTER EMAIL PASSWORD #######
   ************************************************************************/

  String validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';

    if (value.length < 8)
      return 'Must be at least 8 characters long';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF LOGIN FORM IS VALID BEFORE SUBMITTING ######
   *******************************************************************/
  bool validateAndSave() {
    final form = _form.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ###### FOR VALIDATING LOGIN BTN #######
   *********************************************************/
  validateLoginBtnAndSubmit() async {
    if (validateAndSave()) {

      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });
      try {
        print("$email, $password");

        // ===> THIS HELPS ADMIN/S TO LOGIN AS THEIR CREDENTIALS HAVE
        // BEEN CREATED IN THE DB <===

        // ===> This helps to get the uid in the dB <===
        User user = _auth.currentUser;

        db.collection("admins").get().then((snapshot) {
          snapshot.docs.forEach((result) {
            if (result.data()['username'] != loginEmailController.text.trim()) {
              // ===> Login not successful. Display error message to user <===
              final errorMsg = AuthExceptionHandler.generateExceptionMessage(user);
              _showAlertDialog(errorMsg);
            } else if (result.data()['password'] !=
                loginPasswordController.text.trim()) {
              // ===> Login not successful. Display error message to user <===
              final errorMsg = AuthExceptionHandler.generateExceptionMessage(user);
              _showAlertDialog(errorMsg);
            }
            else {
              setState(() {
                loginEmailController.text = " ";
                loginPasswordController.text = " ";
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            }
            // ===> SETTING CIRCULAR PROGRESS BAR TO FALSE <===
            setState(() {
              loading = false;
            });
          });
        });
      } catch (e) {
        print(e);
      }
    }
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ###### FOR DISPLAYING LOGIN ERROR DIALOG TO USER ######
   *******************************************************************/
  _showAlertDialog(errorMsg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Login Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: NotificationListener<OverscrollIndicatorNotification>(
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },

            // ===> I HAVE REMOVED THE SINGLE CHILD SCROLL VIEW <===
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        // Color(0xFF56ccf2),
                        // Color(0xFF56ccf2)
                        Color(0xFFff1744),
                        Color(0xFFff1744),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                // ignore: slash_for_doc_comments
                /**********************************************************
                    ####### FOR LOGO IMAGE ########
                 ***********************************************************/
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // ===> THE HEADER TEXT STARTS HERE <===
                    Padding(
                      padding: EdgeInsets.only(top: 65.0), //Push this Up. Changed it from 120
                      child: Text(
                        "I.T SUPPORT SERVICE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    // ===> CONTAINER FOR TEXT INPUTS <===
                    Container(
                      padding: EdgeInsets.only(top: 115.0),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.topCenter,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Card(
                                elevation: 2.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Form(
                                  key: _form,
                                  autovalidate: _autoValidate,
                                  child: Container(
                                    width: 300.0,
                                    height: 300.0,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 20.0,
                                              left: 25.0,
                                              right: 25.0),
                                          child: TextFormField(
                                            maxLines: 1,
                                            autofocus: false,
                                            focusNode: myFocusNodeEmailLogin,
                                            controller: loginEmailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onChanged: (value) {
                                              email = value;
                                            },
                                            validator: validateEmail,
                                            onSaved: (value) => email = value,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              labelText: "Email Address",
                                              //hintText: "Email Address",
                                              hintStyle:
                                                  TextStyle(fontSize: 17.0),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250.0,
                                          height: 1.0,
                                          color: Colors.grey[400],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 20.0,
                                              left: 25.0,
                                              right: 25.0),
                                          child: TextFormField(
                                            focusNode: myFocusNodePasswordLogin,
                                            controller: loginPasswordController,
                                            obscureText: _obscureTextLogin,
                                            onChanged: (value) {
                                              password = value;
                                            },
                                            validator: validatePassword,
                                            onSaved: (value) =>
                                                password = value,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              labelText: "Password",
                                              //hintText: "Password",
                                              hintStyle:
                                                  TextStyle(fontSize: 17.0),
                                              suffixIcon: GestureDetector(
                                                onTap: _toggleLogin,
                                                child: Icon(
                                                  _obscureTextLogin
                                                      ? FontAwesomeIcons.eye
                                                      : FontAwesomeIcons
                                                          .eyeSlash,
                                                  size: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ignore: slash_for_doc_comments
                              /**********************************************************
                            ####### FOR LOGIN BUTTON ########
                         ***********************************************************/

                              Container(
                                margin: EdgeInsets.only(top: 230.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      // color: Color(0xFF008ECC),
                                      color: Color(0xFFff1744),
                                      offset: Offset(0.0, 0.0),
                                      //blurRadius: 20.0,
                                    ),
                                    BoxShadow(
                                      // color: Color(0xFF008ECC),
                                      color: Color(0xFFff1744),
                                      offset: Offset(0.0, 0.0),
                                      //blurRadius: 20.0,
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                      colors: [
                                        // Color(0xFF008ECC), //Colors is Olympic blue
                                        // Color(0xFF008ECC),

                                        Color(0xFFff1744),
                                        Color(0xFFff1744),
                                      ],
                                      begin: const FractionalOffset(0.2, 0.2),
                                      end: const FractionalOffset(1.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: MaterialButton(
                                  onPressed: validateLoginBtnAndSubmit,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 80.0),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 120, top: 267),
                                child: FlatButton(
                                    // splashColor: Color(0xFF56ccf2),
                                    splashColor: Color(0xFFff1744),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    child: Text(
                                      "Login as User",
                                      style: TextStyle(
                                        //decoration: TextDecoration.underline,
                                        color: Colors.grey,
                                      ),
                                    )),
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
          ),
        ),
      ),
    );
  }
}

// ignore: slash_for_doc_comments
/**********************************************************
    ########## METHOD FOR ON BACK PRESS ##########
 *********************************************************/
Future<bool> _onBackPressed() async {
  var context;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 6,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context),
        );
      });
}

Widget _buildDialogContent(BuildContext context) => Container(
  height: 280,
  decoration: BoxDecoration(
    color: Colors.brown,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  child: Column(
    children: <Widget>[
      Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 80,
            width: 80,
            child: Icon(
              Icons.person_outline,
              size: 90,
              color: Colors.brown,
            ),
          ),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
      ),
      SizedBox(height: 24),
      Text(
        "Do you want to exit?".toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(right: 35, left: 35),
        child: Text(
          "Press No to remain here or Yes to exit",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            //fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "No",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          RaisedButton(
            color: Colors.white,
            child: Text(
              "Yes".toUpperCase(),
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    ],
  ),
);