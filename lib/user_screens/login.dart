import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:it_support/constant/transitionroute.dart';
import 'package:it_support/enum/auth_result_status.dart';
import 'package:it_support/services/auth_exception_handler.dart';
import 'package:it_support/services/firebase_auth_helper.dart';
import 'package:it_support/shared/terms_of_use.dart';
import 'dashboard.dart';
import 'screens.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _regformKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  String email;
  String password;
  String uid;
  User user;
  bool loading = false;
  bool _autoValidate = false;
  String errorMsg = " ";


  //=====> FOR INSTANCES OF FIREBASE <=====
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  TextEditingController signupEmailController = TextEditingController();
  //TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  //TextEditingController signupConfirmPasswordController = TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();

    // Clean up controllers when disposed
    loginEmailController.dispose();
    loginPasswordController.dispose();

    super.dispose();
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING BOTH LOGIN & REGISTER EMAIL #######
   ****************************************************************/
  String validateEmail(String value){
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

  String validatePassword(String value){
    if (value.isEmpty)  return 'Password is required';

    if (value.length < 8) return 'Must be at least 8 characters long';

    else return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF LOGIN FORM IS VALID BEFORE SUBMITTING ######
   *******************************************************************/
  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************************
      ##### CHECKING IF SIGN-UP FORM IS VALID BEFORE SUBMITTING ######
   **********************************************************************/
  bool validateAndSaveRegForm(){
    final form = _regformKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else {
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

        final user =
            await FirebaseAuthHelper().login(email: email, password: password);

        // ===> SETTING CIRCULAR PROGRESS BAR TO FALSE <===
        setState(() {
          loading = false;
        });
        if (user == AuthResultStatus.successful) {
          // Login successful. Navigate to Home Screen
          Navigator.push(context, TransitionPageRoute(widget: DashboardScreen()));

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DashboardScreen()),
        //   );
        }
        // else if(user.uid == "aMDsuSJ9h6eIJuWX0SvwmXJTvTJ3"){}

        else {
          final errorMsg = AuthExceptionHandler.generateExceptionMessage(user);
          _showAlertDialog(errorMsg);
        }
      }
      catch (e){
        print(e);
      }
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
          ######## FOR VALIDATING REGISTER BTN #######
   *********************************************************/
  validateRegisterBtnAndSubmit() async {
    if (validateAndSaveRegForm()) {

      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });
      try {
        print("$email and $password");
        final user =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // ===> SETTING CIRCULAR PROGRESS BAR TO FALSE <===
        setState(() {
          loading = false;
        });
        if (user != null) {

          // ===> Registration successful. Navigate to Home Screen <===
          Navigator.push(context, TransitionPageRoute(widget: DashboardScreen()));

          // ===> This helps to get the uid in the dB <===
          User user = _auth.currentUser;

          // ===> Am using the uid to make data retrieving easier <===
          db.collection('users').doc(user.uid).set(
            {
              'email': email,
              'uid': user.uid,
            }
          ).then((_){
            print("success!");
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => DashboardScreen()),
          // );
        } else {
          // ===> Registration not successful. Display error message to user <===
          final errorMsg = AuthExceptionHandler.generateExceptionMessage(user);
          _showAlertDialog(errorMsg);
        }
      }
      catch (e){
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
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: NotificationListener<OverscrollIndicatorNotification>(
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
                      // Color(0xFF56ccf2),
                      // Color(0xFF56ccf2)
                      Color(0xFFff1744),
                      Color(0xFFff1744),

                      /*
                      Color(0xFFd04ed6),
                      Color(0xFF834d9b)
                      * */
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
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

                    // child: Image(
                    //     width: 50.0,
                    //     height: 50.0,
                    //     fit: BoxFit.fill,
                    //     color: Colors.white,
                    //     image: AssetImage('assets/images/it_support.png')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,

                    // ignore: slash_for_doc_comments
                    /**********************************************************
                        ####### FOR ALIENATING BETWEEN LOGIN AND SIGN-UP ######
                     ***********************************************************/
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: _buildSignUp(context),
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
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();

    //Calling the autoLoginUser in the init state
    // autoLoginUser().then((user) {
    //   if (user != null) {
    //     DashboardScreen();
    //   }
    // });
  }

  // void showInSnackBar(String value) {
  //   FocusScope.of(context).requestFocus(new FocusNode());
  //   _loginFormKey.currentState?.removeCurrentSnackBar();
  //   _loginFormKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(
  //       value,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 16.0,
  //       ),
  //     ),
  //     backgroundColor: Colors.blue,
  //     duration: Duration(seconds: 3),
  //   ));
  // }

  // ignore: slash_for_doc_comments

  // ignore: slash_for_doc_comments
  /**********************************************************
                ####### FOR MENU BAR ########
   ***********************************************************/

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
              ####### FOR LOGIN ########
   ***********************************************************/
  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            maxLines: 1,
                            autofocus: false,
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            validator: validateEmail,
                            onSaved: (value) => email = value,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),

                              /*
                             *  icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                             * */

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
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: validatePassword,
                            onSaved: (value) => password = value,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              //COMMENTING OUT ICON
                              /*
                              * icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              * */

                              labelText: "Password",
                              hintText: "********",
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
                         ####### FOR FORGOT PASSWORD ########
               ***********************************************************/
              Padding(
                padding: EdgeInsets.only(left: 120, top: 195),
                child: FlatButton(
                  splashColor: Color(0xFFff1744),
                    // splashColor: Color(0xFF56ccf2),
                    onPressed: () {
                      Navigator.push(context, TransitionPageRoute(widget: Forgetpwd()));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Forgetpwd()),
                      // );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        //decoration: TextDecoration.underline,
                        color: Colors.grey,
                      ),
                    )),
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
                      color: Color(0xFFff1744),
                      // color: Color(0xFF008ECC),
                      offset: Offset(0.0, 0.0),
                      //blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Color(0xFFff1744),
                      // color: Color(0xFF008ECC),
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
                  //highlightColor: Colors.transparent,
                  //splashColor: Color(0xFFf7418c),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 80.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  onPressed: validateLoginBtnAndSubmit,
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
                            builder: (context) => AdminLogin()),
                      );
                    },
                    child: Text(
                  "Login as Admin",
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
    );
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
                 ####### FOR REGISTER ########
   ***********************************************************/

  // COMMENTING OUT OLD REGISTRATION FORM
  /*
  *
  *  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),

                       // COMMENTING OUT NAME TEXT FIELD
                       /*
                       *  child: TextFormField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                          ),
                        ),
                       * */
                      ),

                      /*
                      * Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      * */

                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
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
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),

                      // COMMENTING OUT CONFIRM PASSWORD FIELD
                      /*
                      *  Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      * */

                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 340.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFfbab66),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Color(0xFFf7418c),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                          Color(0xFFf7418c),
                          Color(0xFFfbab66)
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Color(0xFFf7418c),
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        showInSnackBar("SignUp button pressed")),
              ),
            ],
          ),
        ],
      ),
    );
  }
  * */

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  key: _regformKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            maxLines: 1,
                            autofocus: false,
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            onSaved: (value) {
                              email = value;
                            },
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              //COMMENTING OUT ICON
                              /*
                              * icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              * */

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
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            validator: validatePassword,
                            onSaved: (value) {
                              password = value;
                            },
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              //COMMENTING OUT ICON
                              /*
                              * icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              * */

                              labelText: "Password",
                              hintText: "********",
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
                        ####### FOR REGISTER BUTTON ########
               ***********************************************************/
              Container(
                margin: EdgeInsets.only(top: 230.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      // color: Color(0xFF008ECC),
                      color: Color(0xFFff1744),
                      offset: Offset(0.0, 0.0),
                      //blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Color(0xFFff1744),
                      // color: Color(0xFF008ECC),
                      offset: Offset(0.0, 0.0),
                      //blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFFff1744),
                        Color(0xFFff1744),
                        // Color(0xFF008ECC),
                        // Color(0xFF008ECC),
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  //highlightColor: Colors.transparent,
                  //splashColor: Color(0xFFf7418c),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: validateRegisterBtnAndSubmit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 65.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  // onPressed: validateAndSubmit,
                ),
              ),
            ],
          ),

          //REGISTRATION BUTTON USED TO BE HERE
          /*
          * // ignore: slash_for_doc_comments
          /**********************************************************
                     ####### FOR REGISTER BUTTON ########
           ***********************************************************/
          Container(
            margin: EdgeInsets.only(top: 20.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color:  Color(0xFF008ECC),
                  offset: Offset(0.0, 0.0),
                  //blurRadius: 20.0,
                ),
                BoxShadow(
                  color:  Color(0xFF008ECC),
                  offset: Offset(0.0, 0.0),
                  //blurRadius: 20.0,
                ),
              ],
              gradient: LinearGradient(
                  colors: [
                    Color(0xFF008ECC),
                    Color(0xFF008ECC),
                  ],
                  begin: const FractionalOffset(0.2, 0.2),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: MaterialButton(
              //highlightColor: Colors.transparent,
              //splashColor: Color(0xFFf7418c),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 90.0),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                onPressed: () =>
                    showInSnackBar("Register button pressed")),
          ),
          * */

          //===> For Terms & Conditions <===
          //buildText('By signing up you agree with our Terms & Conditions.', 12.0),
          TermsOfUse(),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
