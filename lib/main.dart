import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_support/screen/login.dart';

// ignore: slash_for_doc_comments
/************************************************************
    ###### Added the Extra ones for portrait mode only ######
 ************************************************************/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

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
      home: LoginScreen(),
    );
  }
}