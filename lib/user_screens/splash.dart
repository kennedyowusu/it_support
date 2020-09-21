import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:it_support/user_screens/dashboard.dart';
import 'package:it_support/user_screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //===> CREATING INSTANCE OF FIREBASE <===
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ===> THIS FUNCTION IS SPINKIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();

    // ===> CREATING FUNCTION FOR displaySplash <===
    displaySplash();

  }

  @override
  Widget build(BuildContext context) {

    //=====> FOR LOGO/TEXT <=====
    Widget logo() {
      return Center(
        child: Padding(
          // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          padding: EdgeInsets.only(top: 200),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            child: Column(
             children: [
               Stack(
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
               SizedBox(height: 10,),
               Center(
                 child: Padding(
                   padding: EdgeInsets.only(right: 25, left: 25,),
                   child: Container(
                     child: Text("I.T support service 24/7".toUpperCase(),
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                     ),
                   ),
                 ),
               ),

               // ===> ADDING SPIN HERE <===
               Padding(
                 padding: EdgeInsets.all(8.0),
                 child: spinkit,
               ), // CALLING THE SPINKIT FUNCTION HERE
             ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Color(0xFFff1744),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              logo(),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ));
  }

  // ===> IMPLEMENTING THE displaySplash FUNCTION <===
  displaySplash() {

    // ===> DURATION OF THE SPLASH SCREEN <===
    Timer((Duration(seconds: 5)), () async {

      // ===> MEANING THE USER IS STILL LOGGED IN <===
      if (await auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => DashboardScreen());
        Navigator.pushReplacement(context, route);
      }

      // ===> MEANING THE USER HAS LOGGED OUT <===
      else {
        Route route = MaterialPageRoute(builder: (_) => LoginScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
}