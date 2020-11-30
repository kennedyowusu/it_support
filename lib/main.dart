import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_support/services/authhelper.dart';
import 'package:it_support/user_screens/dashboard.dart';
import 'package:it_support/user_screens/login.dart';
import 'package:it_support/widget/spinkit.dart';

import 'admin/admin_dashboard.dart';


// ignore: slash_for_doc_comments
/*****************************************************************
    ###### Added the Extra ones for portrait mode only ######

    Since Firebase versions have been updated, i have to call
    Firebase.initializeApp() before using any Firebase product
    I also have to add firebase_core in the pubspec.yaml file
 *****************************************************************/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

// final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IT SUPPORT',
      theme: ThemeData(
        backgroundColor:  Color(0xFF008ECC),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RoleChecker(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => DashboardScreen(),
        },

      // StreamBuilder(
      //   stream: auth.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       //===> User is signed in! <===
      //       return SplashScreen();
      //     }
      //     //==> User is currently signed out! <===
      //     return LoginScreen();
      //   },
      // ),
      // routes: <String, WidgetBuilder>{
      //   '/home': (BuildContext context) => DashboardScreen(),
      //   '/login': (BuildContext context) => LoginScreen()
      // },
    );
  }
}


class RoleChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc.data();
                  print(user['role']);
                  return (user['role'] == 'admin')
                      ? AdminDashboard()
                      : DashboardScreen();
                } else {
                  return Material(
                    child: Center(
                      child: spinkit,
                    ),
                  );
                }
              },
            );
          }
          return LoginScreen();
        });
  }
}

