import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_support/constant/transitionroute.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'admin_login.dart';

class NetworkIssuesRaised extends StatefulWidget {
  @override
  _NetworkIssuesRaisedState createState() => _NetworkIssuesRaisedState();
}

class _NetworkIssuesRaisedState extends State<NetworkIssuesRaised> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  // ===> FOR CHANGING BG COLOR WHEN INDEX IS SELECTED <===
  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //This if for sign out
  signOut() async {
    await auth.signOut();
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ####### FOR _displayIssueDialog ########
   ***********************************************************/

  _displayIssueDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _buildViewIssueDialogContent(context),
          );
        });
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ####### FOR _buildViewIssueDialogContent ########
   ***********************************************************/

  Widget _buildViewIssueDialogContent(BuildContext context) =>
      Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            // Container(
            //   child: Padding(
            //     padding: EdgeInsets.all(12.0),
            //     child: Container(
            //       height: 80,
            //       width: 80,
            //       child: Icon(
            //         MdiIcons.vote,
            //         size: 90,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            //   ),
            // ),
            SizedBox(height: 24),
            Text(
              "STUDENT ISSUE RAISED".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 100,
              height: 1,
              color: Colors.black54,
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Container(
                // color: Colors.greenAccent,
                height: 170,
                width: 250,
                child: StreamBuilder<QuerySnapshot>(
                    stream: db.collection("network_issues").snapshots(),
                    // ignore: missing_return
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text("Loading..."));
                      }
                      return ListView(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                          Center(
                            child: Text(
                              document.data()['student query'],
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.double,
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ),
            ),

            Container(
              height: 50,
              width: 210,
              color: Colors.yellow,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Leave Open",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(height: 58),
                  RaisedButton(
                    elevation: 2,
                    color: Colors.white,
                    child: Text(
                      "CLOSE".toUpperCase(),
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      print('Close the issue');
                      // return Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      );

  // ignore: slash_for_doc_comments
  /**********************************************************
            ####### FOR removeFromDb ########

      When we swipe an entry from right to left or left to right,
      we will call removeFromDb() and delete the entry from our
      Firestore database.
   ***********************************************************/

  void removeFromDb(documentID) {
    db.collection('network_issues').doc(documentID).delete();
    // interact();
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
              ####### FOR deleteData ########
   ***********************************************************/
  // deleteData () async {
  //   await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
  //     myTransaction.delete(snapshot.data.documents[index].reference);
  //   });
  // }


  void undoDeletion(index, list){
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState((){
      list.insert(index, list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          // backgroundColor: Color(0xFF56ccf2),
          backgroundColor: Color(0xFFff1744),
          title: Text("Network Issues".toUpperCase()),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                icon: Icon(
                  MdiIcons.logout,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  signOut();

                  Navigator.push(
                      context, TransitionPageRoute(widget: AdminLogin()));

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => AdminLogin()),
                  // );
                })
          ],
        ),
        // body: StreamBuilder<Object>(
        //     stream: FirebaseFirestore.instance.collection("software_issues").snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     return ListView.builder(
        //         padding: EdgeInsets.all(16),
        //         itemCount: snapshot.data.documents.length,
        //         itemBuilder: (context, index) {
        //           return Container(
        //             padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        //             height: 180,
        //             width: double.maxFinite,
        //             child: Card(
        //               elevation: 5,
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Padding(
        //                     padding: EdgeInsets.all(10.0),
        //                     child: Container(
        //                       width: 90.0,
        //                       height: 90.0,
        //                       child: CircleAvatar(
        //                         radius: 32,
        //                         backgroundColor: Colors.white,
        //                         backgroundImage: AssetImage(
        //                             "assets/images/imgplaceholder.png"),
        //                       ),
        //                     ),
        //                   ),
        //                   // SizedBox(
        //                   //   width: 1,
        //                   // ),
        //                     Padding(
        //                       padding: EdgeInsets.only(top: 30,),
        //                       child: Container(
        //                         width: 150,
        //                         child: Column(
        //                           children: [
        //                             // SizedBox(height: 5,),
        //                             Text(snapshot.data.documents[index].data["name"]),
        //                             SizedBox(height: 10,),
        //                             // Text("STUDENT EMAIL"),
        //                             // SizedBox(height: 10,),
        //                             // Text("PHONE NUMBER"),
        //                             // SizedBox(height: 5,),
        //                             RaisedButton(
        //                               color: Color(0xFF008ECC),
        //                                 onPressed: _displayIssueDialog,
        //                                 child: Text("VIEW ISSUE",
        //                                 style: TextStyle(
        //                                   color: Colors.white,
        //                                 ),),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     )
        //                 ],
        //               ),
        //             ),
        //           );
        //         });
        //   }
        // ));

        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection("network_issues").snapshots(),
            // ignore: missing_return
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(child: Text("Loading..."));
              // }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff1744),),
                ));
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data.docs[index];
                    final documentID = snapshot.data.docs[index].id;
                    final list = snapshot.data.docs;
                    return Dismissible(
                      // Specify the direction to swipe and delete
                      direction: DismissDirection.endToStart,

                        //dismiss when dragged 70% towards the left.
                        dismissThresholds: {
                          // DismissDirection.startToEnd: 0.1,
                          DismissDirection.endToStart: 0.7
                        },

                      // confirmDismiss: (direction) => promptUser(direction),
                      // Each Dismissible must contain a Key. Keys allow
                      // Flutter to uniquely identify widgets.

                      key: Key(documentID),
                      onDismissed: (direction) {
                        removeFromDb(documentID);
                        setState(() {
                          // Remove the item from the data source.
                          list.removeAt(index);

                          String action;
                          if (direction == DismissDirection.endToStart) {
                            removeFromDb(documentID);
                            action = "deleted";
                          }
                          //To show a snackbar with the UNDO button
                          Scaffold.of(context).showSnackBar(SnackBar(

                            // Shows the information on Snackbar
                            content: Text("data $action"),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                 label: " ",
                                onPressed: (){
                                  //To undo deletion
                                  undoDeletion(index, list);
                                },
                              )
                          ));

                          // _key.currentState
                          //     .showSnackBar(
                          //   SnackBar(
                          //     content: Text("$action. Do you want to undo?"),
                          //     duration: Duration(seconds: 5),
                          //     action: SnackBarAction(
                          //         label: "Undo",
                          //         textColor: Colors.yellow,
                          //         onPressed: () {
                          //           //To undo deletion
                          //           undoDeletion(index, list);
                          //           // Deep copy the email
                          //           // final copiedEmail = Email.copy(swipedEmail);
                          //           // Insert it at swiped position and set state
                          //           // setState(() => list.insert(index, copiedEmail));
                          //         }),
                          //   ),
                          // )
                          //     .closed
                          //     .then((reason) {
                          //   if (reason != SnackBarClosedReason.action) {
                          //     // The SnackBar was dismissed by some other means
                          //     // that's not clicking of action button
                          //     // Make API call to backend
                          //
                          //   }
                          // });
                          // Scaffold.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text("Data $documentID $action"),
                          //   ),
                          // );
                          // else {
                          //   archiveItem();
                          //   action = "archived";
                          // }
                        });
                      },
                      // ===> Show a red background as the item is swiped away <===
                      background: Container(
                        color: Colors.amber,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      child: GestureDetector(
                        // onLongPress: showDeleteDialog,
                        onTap: () => _onSelected(index),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.only(
                          //       topRight: Radius.circular(10.0),
                          //       bottomRight: Radius.circular(10.0)),
                          //   // color: Colors.white,
                          //   boxShadow: [
                          //     BoxShadow(color: Colors.green, spreadRadius: 3),
                          //   ],
                          // ),

                          //==> change bg color when index is selected ==>
                          color: _selectedIndex != null &&
                              _selectedIndex == index
                              ? Colors.grey[100]
                              : Colors.white,
                          padding: EdgeInsets.only(
                              top: 15, left: 10, right: 10),
                          height: 180,
                          width: double.maxFinite,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0),

                                  // child: Container(
                                  //   width: 90.0,
                                  //   height: 90.0,
                                  //   child: CircleAvatar(
                                  //     radius: 32,
                                  //     backgroundColor: Colors.white,
                                  //     backgroundImage: AssetImage(
                                  //         "assets/images/imgplaceholder.png"),
                                  //   ),
                                  // ),

                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30, left: 1),
                                  child: Column(
                                    children: [

                                      // Text(document.data()['name'],
                                      //   style: TextStyle(
                                      //     decorationStyle: TextDecorationStyle.double,
                                      //     color: Colors.black,
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.w700,
                                      //   ),
                                      // ),
                                      // SizedBox(height: 10,),

                                      Text(
                                        document.data()['student number'],
                                        style: TextStyle(
                                          decorationStyle: TextDecorationStyle
                                              .double,
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(document.data()['student phone'],
                                        style: TextStyle(
                                          decorationStyle: TextDecorationStyle
                                              .double,
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Text(document.data()['student email'],
                                        style: TextStyle(
                                          decorationStyle: TextDecorationStyle
                                              .double,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(document.data()['student semester'],
                                        style: TextStyle(
                                          decorationStyle: TextDecorationStyle
                                              .double,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      // Container(
                                      //   height: 40,
                                      //   decoration: BoxDecoration(
                                      //       color: Color(0xFF008ECC),
                                      //     borderRadius: BorderRadius.circular(10,)
                                      //   ),
                                      //   child: FlatButton(
                                      //     onPressed: _displayIssueDialog,
                                      //     child: Text("VIEW ISSUE",
                                      //       style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontWeight: FontWeight.bold
                                      //       ),),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 1,
                                  height: 130,
                                  // color: Color(0xFF008ECC),
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Container(
                                      height: 120,
                                      width: 145,
                                      // color: Colors.redAccent,
                                      child: SingleChildScrollView(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              document.data()['student query'],
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                            ),
                                          ))),
                                ),
                                // ListTile(
                                //   title: Text(document.data()['name']),
                                //   subtitle: Text(document.data()['student email']),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
              // return ListView(
              //   padding: EdgeInsets.all(16),
              //   children: snapshot.data.docs.map((DocumentSnapshot document) {
              //     return Container(
              //       // color: _selectedIndex != null && _selectedIndex == index
              //       //     ? Colors.red
              //       //     : Colors.white,
              //       padding: EdgeInsets.only(top: 15, left: 10, right: 10),
              //       height: 180,
              //       width: double.maxFinite,
              //       child: Card(
              //         elevation: 5,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.all(5.0),
              //
              //               // child: Container(
              //               //   width: 90.0,
              //               //   height: 90.0,
              //               //   child: CircleAvatar(
              //               //     radius: 32,
              //               //     backgroundColor: Colors.white,
              //               //     backgroundImage: AssetImage(
              //               //         "assets/images/imgplaceholder.png"),
              //               //   ),
              //               // ),
              //
              //             ),
              //             Padding(
              //               padding: EdgeInsets.only(top: 30, left: 1),
              //               child: Column(
              //                 children: [
              //
              //                   // Text(document.data()['name'],
              //                   //   style: TextStyle(
              //                   //     decorationStyle: TextDecorationStyle.double,
              //                   //     color: Colors.black,
              //                   //     fontSize: 20,
              //                   //     fontWeight: FontWeight.w700,
              //                   //   ),
              //                   // ),
              //                   // SizedBox(height: 10,),
              //
              //                   Text(
              //                     document.data()['student number'],
              //                     style: TextStyle(
              //                       decorationStyle: TextDecorationStyle.double,
              //                       color: Colors.black,
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.w700,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 9,
              //                   ),
              //                   Text(document.data()['student phone'],
              //                     style: TextStyle(
              //                       decorationStyle: TextDecorationStyle.double,
              //                       color: Colors.black87,
              //                       fontSize: 16,
              //                     ),),
              //                   SizedBox(
              //                     height: 9,
              //                   ),
              //                   Text(document.data()['student email'],
              //                     style: TextStyle(
              //                       decorationStyle: TextDecorationStyle.double,
              //                       color: Colors.black87,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 6,
              //                   ),
              //                   Text(document.data()['student semester'],
              //                     style: TextStyle(
              //                       decorationStyle: TextDecorationStyle.double,
              //                       color: Colors.black87,
              //                     ),
              //                   ),
              //
              //                   // Container(
              //                   //   height: 40,
              //                   //   decoration: BoxDecoration(
              //                   //       color: Color(0xFF008ECC),
              //                   //     borderRadius: BorderRadius.circular(10,)
              //                   //   ),
              //                   //   child: FlatButton(
              //                   //     onPressed: _displayIssueDialog,
              //                   //     child: Text("VIEW ISSUE",
              //                   //       style: TextStyle(
              //                   //         color: Colors.white,
              //                   //         fontWeight: FontWeight.bold
              //                   //       ),),
              //                   //   ),
              //                   // )
              //                 ],
              //               ),
              //             ),
              //             SizedBox(
              //               width: 15,
              //             ),
              //             Container(
              //               width: 1,
              //               height: 130,
              //               // color: Color(0xFF008ECC),
              //               color: Colors.black54,
              //             ),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             Padding(
              //               padding: EdgeInsets.only(top: 20, bottom: 20),
              //               child: Container(
              //                   height: 120,
              //                   width: 145,
              //                   // color: Colors.redAccent,
              //                   child: SingleChildScrollView(
              //                       child: Align(
              //                         alignment: Alignment.center,
              //                         child: Text(
              //                           document.data()['student query'],
              //                           style: TextStyle(
              //                               color: Colors.black
              //                           ),
              //                         ),
              //                       ))),
              //             ),
              //             // ListTile(
              //             //   title: Text(document.data()['name']),
              //             //   subtitle: Text(document.data()['student email']),
              //             // ),
              //           ],
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // );
            }));
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

  Widget _buildDialogContent(BuildContext context) =>
      Container(
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
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
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
}