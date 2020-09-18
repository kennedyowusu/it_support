import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_support/constant/clipper.dart';
import 'package:it_support/constant/txtformfield.dart';

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;

  //====> Creating variables <====
  String _email;
  String _password;
  User user;
  bool _loading = false;
  bool _autoValidate = false;
  bool _obscureTextLogin = true;
  String errorMsg = "";

  //=====> FOR INSTANCES OF FIREBASE <=====
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    //=====> FOR LOGO/TEXT <=====
    Widget logo() {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                    child: Align(
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        width: 150,
                        height: 150,
                        child: Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 60,
                              child: Center(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('24/7 SUPPORT SERVICE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        // color: Theme.of(context).primaryColor,
                                        color: Colors.red
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                    height: 154,
                  )),
              // Positioned(
              //   child: Container(
              //       height: 154,
              //       child: Align(
              //         child: CircleAvatar(
              //           child: Text(
              //             "IT Support Service".toUpperCase(),
              //             style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.bold,
              //                 // color: Theme.of(context).primaryColor,
              //                 color: Colors.red
              //             ),
              //           ),
              //         ),
              //
              //       )),
              // ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.height * 0.046,
                right: MediaQuery.of(context).size.width * 0.22,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.32,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //=====> FOR BUTTON WIDGET <=====
    Widget filledButton(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, void function()) {
      return RaisedButton(
        highlightElevation: 0.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 0.0,
        color: fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    outlineButton(void function()) {
      return OutlineButton(
        highlightedBorderColor: Colors.white,
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        highlightElevation: 0.0,
        splashColor: Colors.white,
        highlightColor: Color(0xFFff1744),
        color: Color(0xFFff1744),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: Text(
          "REGISTER",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    // ignore: slash_for_doc_comments
    /***************************************************************
            ######## FOR VALIDATING _validateLoginInput #######
     ****************************************************************/
    void _validateLoginInput() async {
      final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;
        });
        if (user != null) {
          try {
            user = (await _auth
                .signInWithEmailAndPassword(email: _email, password: _password)) as User;
            // Navigator.push(context, TransitionPageRoute(widget: DashboardScreen()));
            Navigator.of(context).pushReplacementNamed('/DashboardScreen');
          }
          catch (error) {
            switch (error.code) {
              case "ERROR_USER_NOT_FOUND":
                {
                  _sheetController.setState(() {
                    errorMsg =
                    "There is no user with such entries. Please try again.";

                    _loading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            child: Text(errorMsg),
                          ),
                        );
                      });
                }
                break;
              case "ERROR_WRONG_PASSWORD":
                {
                  _sheetController.setState(() {
                    errorMsg = "Password doesn\'t match your email.";
                    _loading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            child: Text(errorMsg),
                          ),
                        );
                      });
                }
                break;
              default:
                {
                  _sheetController.setState(() {
                    errorMsg = "";
                  });
                }
            }
          }
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }


    // ignore: slash_for_doc_comments
    /****************************************************************
            ######## FOR VALIDATING _validateRegisterInput #######
     ****************************************************************/
    void _validateRegisterInput() async {
      final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;
        });

        if (user != null) {
          try {
            user = (await _auth
                .createUserWithEmailAndPassword(
                email: _email, password: _password)) as User;

            {
              // Registration successful. Navigate to Home Screen
              // Navigator.push(context, TransitionPageRoute(widget: DashboardScreen()));
              Navigator.of(context).pushReplacementNamed('/DashboardScreen');

              //=====> This helps to get the uid in the dB <=====
              User user = _auth.currentUser;

              //=====> Am using the uid to make data retrieving easier <=====
              db.collection('users').doc(user.uid).set(
                  {
                    'email': _email,
                    'uid': user.uid,
                  }).then((onValue) {
                _sheetController.setState(() {
                  _loading = false;
                });
              });
            };
          }
          catch (error) {
            switch (error.code) {
              case "ERROR_EMAIL_ALREADY_IN_USE":
                {
                  _sheetController.setState(() {
                    errorMsg = "This email is already in use.";
                    _loading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            child: Text(errorMsg),
                          ),
                        );
                      });
                }
                break;
              case "ERROR_WEAK_PASSWORD":
                {
                  _sheetController.setState(() {
                    errorMsg = "The password must be 6 characters long or more.";
                    _loading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            child: Text(errorMsg),
                          ),
                        );
                      });
                }
                break;
              default:
                {
                  _sheetController.setState(() {
                    errorMsg = "";
                  });
                }
            }
          }
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }


    // ignore: slash_for_doc_comments
    /***************************************************************
            ######## FOR VALIDATING emailValidator #######
     ****************************************************************/
    String emailValidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)'
          r'|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.'
          r'[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.isEmpty) return '*Required';
      if (!regex.hasMatch(value))
        return '*Enter a valid email address';
      else
        return null;
    }


      //=====> FOR loginSheetT <=====
    void loginSheet() {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Color(0xFFff1744),
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Align(
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFff1744),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      child: Text(
                                        "Sign In".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20, top: 60),
                                child: CustomTextField(
                                  onSaved: (input) {
                                    _email = input;
                                  },
                                  validator: emailValidator,
                                  icon: Icon(Icons.email,
                                    color: Theme.of(context).primaryColor,),
                                  hint: "Email Address",
                                )),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: CustomTextField(
                                  icon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  obsecure: _obscureTextLogin,
                                  onSaved: (input) => _password = input,
                                  validator: (input) =>
                                  input.isEmpty ? "*Required" : null,
                                  labelText: "Password",
                                  hint: "********",
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: _loading == true
                                  ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryColor),
                              )
                                  : Container(
                                child: filledButton(
                                    "Sign In",
                                    Colors.white,
                                    primaryColor,
                                    primaryColor,
                                    Colors.white,
                                    _validateLoginInput),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    //=====> FOR registerSheet <=====
    void registerSheet() {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              padding: EdgeInsets.only(bottom: 50),
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Color(0xFFff1744),
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        child: Column(children: <Widget>[
                          Container(
                            // padding: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Align(
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFff1744),),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    // padding: EdgeInsets.only(bottom: 25, ),
                                    child: Center(
                                      child: Text(
                                        "Sign Up".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 20, top: 35,
                              ),
                              child: CustomTextField(
                                icon: Icon(Icons.email),
                                hint: "Email Address",
                                onSaved: (input) {
                                  _email = input;
                                },
                                validator: emailValidator,
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: CustomTextField(
                                icon: Icon(Icons.lock),
                                obsecure: true,
                                onSaved: (input) => _password = input,
                                validator: (input) =>
                                input.isEmpty ? "*Required" : null,
                                hint: "********",
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: _loading
                                ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primaryColor),
                            )
                                : Container(
                              child: filledButton(
                                  "Sign Up",
                                  Colors.white,
                                  primaryColor,
                                  primaryColor,
                                  Colors.white,
                                  _validateRegisterInput,
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                        key: _formKey,
                        autovalidate: _autoValidate,
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }


    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        // backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Color(0xFFff1744),
        body: Column(
          children: <Widget>[
            logo(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Padding(
              child: Container(
                child: filledButton("LOGIN", primaryColor, Colors.white,
                    Colors.white, primaryColor, loginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: 20,
                  right: 20),
            ),
            Padding(
              child: Container(
                child: outlineButton(registerSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }
}