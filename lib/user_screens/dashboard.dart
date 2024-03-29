import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_support/constant/transitionroute.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'screens.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  String _stName;
  String _stSemester;
  bool loading = false;
  bool _autoValidate = false;

  final FocusNode myFocusNodeSemester = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController studentSemesterController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();

  @override
  void dispose() {
    myFocusNodeSemester.dispose();
    myFocusNodeName.dispose();
    super.dispose();
  }

  // ===> This if for sign out <===
  signOut() async {
    await auth.signOut();
  }


  // ignore: slash_for_doc_comments
  /**********************************************************
       ######## FOR VALIDATING SEMESTER #######
   *********************************************************/
  String validateStudentSemester(String value){
    if (value.isEmpty) {
      return 'Your Semester is required';
    }
    else {
      return null;
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ######## FOR VALIDATING STUDENT NAME #######
   *********************************************************/
  String validateStudentName(String value){
    Pattern pattern =
        r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Name';
    // else if (value.isEmpty) return
    //   'Name is required';
    else
      return null;

  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF FORM IS VALID BEFORE SUBMITTING ######
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
  /**********************************************************
      ####### VALIDATING FORM BEFORE SUBMITTING ########
   ***********************************************************/
  validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        loading = true;
      });
      try{
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );

        //This helps to get the uid in the dB
        // User user = auth.currentUser;
        //
        // //Am using the uid to make data retrieving easier
        // await db.collection("users").doc(user.uid).set({
        //   'uid': user.uid,
        //   'student name': _stName,
        //   'student semester': _stSemester,
        // }).then((_){
        //   print("success!");
        // });

        // CollectionReference db = FirebaseFirestore.instance.collection('users');

        //This helps to get the uid in the dB
        User user = auth.currentUser;

        //Am using the uid to make data retrieving easier
        await db.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'student name': _stName,
          'student semester': _stSemester,
        }).then((_){
          print("success!");
        });;

        // return StreamBuilder<QuerySnapshot>(
        //   stream: db.snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        //     if (!snapshot.hasData) {
        //       return Center(
        //         child: CircularProgressIndicator(
        //             backgroundColor: Color(0xFF56ccf2),
        //         ),
        //       );
        //     }
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Text("loading");
        //     }
        //     return ListView(
        //       children: snapshot.data.docs.map((DocumentSnapshot document){
        //         Text(document.data()['student name']);
        //         // return ListTile(
        //         //   title: Text(document.data()['student name']),
        //         //   subtitle: Text(document.data()['student semester']),
        //         // );
        //       }).toList(),
        //     );
        //   },
        // );

        /**********************************************************
            ####### SHOW DIALOG ON SUBMIT ########
         ***********************************************************/
        // return showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (BuildContext context){
        //       return Dialog(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(50),
        //         ),
        //         elevation: 6,
        //         backgroundColor: Colors.transparent,
        //         child: _buildDialogContent(context),
        //       );
        //     }
        // );
        setState(() {
          loading = false;
        });
      }
      catch(e){
        print(e);
      }
    }
    else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Color(0xFF56ccf2),
          backgroundColor: Color(0xFFff1744),
          title: Text("IT SUPPORT SERVICE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(
                  MdiIcons.logout,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: (){
                  signOut();

                  Navigator.push(context, TransitionPageRoute(widget: LoginScreen()));

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => LoginScreen()),
                  // );

                })
          ],
        ),
        // backgroundColor: Color(0xFF56ccf2),
        backgroundColor: Color(0xFFFAFAFA),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 20),
              child: Column(
                children: [

                  // Container(
                  //   margin: EdgeInsets.only(bottom: 20),
                  //   height: 64,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         height: 90,
                  //         width: 70,
                  //         // margin: EdgeInsets.only(right: 10),
                  //         child: Stack(
                  //           children: [
                  //             CircleAvatar(
                  //               radius: 32,
                  //               // backgroundColor: Color(0xFF778899),
                  //               backgroundColor: Colors.white,
                  //               child: _pickedImage == null ? Image.asset("assets/images/imgplaceholder.png") : null,
                  //               backgroundImage:
                  //               _pickedImage != null ? FileImage(_pickedImage) : null,
                  //               // backgroundImage: AssetImage(
                  //               //     "assets/images/imgplaceholder.png"),
                  //             ),
                  //             Align(
                  //               alignment: Alignment.bottomRight,
                  //               child: Container(
                  //                 height: 30,
                  //                 width: 20,
                  //                 decoration: BoxDecoration(
                  //                   // color: Color(0xFF56ccf2),
                  //                   color: Colors.white,
                  //                   shape: BoxShape.circle,
                  //                 ),
                  //                 child: InkWell(
                  //                   onTap: _displayDialog,
                  //                   child: Icon(
                  //                     MdiIcons.pen,
                  //                     size: 15,
                  //                     color: Color(0xFF56ccf2),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 6,
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //               width: 180,
                  //               child: Column(
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     "Set Your Name",
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 16,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "Set Semester",
                  //                     style: TextStyle(
                  //                       color: Colors.grey[300],
                  //                       fontSize: 13,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               )),
                  //
                  //           // Padding(
                  //           //   padding: EdgeInsets.only(left: 190),
                  //           //   child: Text("Logout",
                  //           //     style: TextStyle(
                  //           //       color: Colors.white,
                  //           //       fontWeight: FontWeight.bold,
                  //           //       fontSize: 13,
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //       Container(
                  //         width: 60,
                  //         height: 80,
                  //         child: Padding(
                  //           padding: EdgeInsets.only(left: 25),
                  //           child: FlatButton(
                  //             onPressed: () {
                  //               signOut();
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => LoginScreen()),
                  //               );
                  //             },
                  //             child: Icon(
                  //               MdiIcons.logout,
                  //               color: Colors.white,
                  //               size: 20,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      primary: false,
                      children: [
                        /* the card was here but i moved it into a class */
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SoftwareIssuesContactForm()),
                            );
                          },
                          title: "Software Issues",
                          icon: IconData(0xe900, fontFamily: 'software_devt'),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HardwareIssuesContactForm()),
                            );
                          },
                          title: "Hardware Issues",
                          icon: IconData(0xe900, fontFamily: 'hardware'),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NetworkIssuesContactForm()),
                            );
                          },
                          title: "Network Issues",
                          icon: IconData(0xe900, fontFamily: 'network'),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InternetConnectivityIssuesContactForm()),
                            );
                          },
                          title: "Internet Connectivity",
                          icon: IconData(0xe900, fontFamily: 'internet'),
                          // color: Color(0xFF56ccf2),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AppDevelopmentIssuesContactForm()),
                            );
                          },
                          title: "App/Web Development",
                          icon: IconData(0xe900, fontFamily: 'app'),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                        CardHolder(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SoftwareDevIssuesContactForm()),
                            );
                          },
                          title: "Software Development",
                          icon: IconData(0xe900, fontFamily: 'software'),
                          color: Color.fromRGBO(63, 63, 63, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardHolder extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Function onTap;

  const CardHolder(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onTap,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // splashColor: Colors.amber,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Icon(
                icon,
                size: 70,
                color: color,
              ),
              // SvgPicture.asset("assets/images/imgplaceholder.png",
              //   height: 128,
              // ),
            ],
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
                  MdiIcons.vote,
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
