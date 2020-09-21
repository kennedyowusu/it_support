import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_support/user_screens/dashboard.dart';
import 'package:it_support/user_screens/splash.dart';

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
      home: SplashScreen(),
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


