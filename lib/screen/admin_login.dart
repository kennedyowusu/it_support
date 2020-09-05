import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens.dart';

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

  String email;
  String password;
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
  validateLoginBtnAndSubmit() {
    if (validateAndSave()) {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFF56ccf2),
                    Color(0xFF56ccf2)
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
                Padding(
                  padding: EdgeInsets.only(top: 120.0), //Push this Up
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
                                          hintStyle: TextStyle(fontSize: 17.0),
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
                                        onSaved: (value) => password = value,
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
                                          hintStyle: TextStyle(fontSize: 17.0),
                                          suffixIcon: GestureDetector(
                                            onTap: _toggleLogin,
                                            child: Icon(
                                              _obscureTextLogin
                                                  ? FontAwesomeIcons.eye
                                                  : FontAwesomeIcons.eyeSlash,
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
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xFF008ECC),
                                  offset: Offset(0.0, 0.0),
                                  //blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Color(0xFF008ECC),
                                  offset: Offset(0.0, 0.0),
                                  //blurRadius: 20.0,
                                ),
                              ],
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF008ECC), //Colors is Olympic blue
                                    Color(0xFF008ECC),
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
                                child: Text("Login",
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
                                splashColor: Color(0xFF56ccf2),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
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
    );
  }
}
