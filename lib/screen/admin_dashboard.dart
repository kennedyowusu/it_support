import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  final db = FirebaseFirestore.instance;



  // ignore: slash_for_doc_comments
  /**********************************************************
          ####### FOR _displayIssueDialog ########
   ***********************************************************/

  _displayIssueDialog(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
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

  Widget _buildViewIssueDialogContent(BuildContext context) => Container(
    height: 280,
    decoration: BoxDecoration(
      color:  Colors.white,
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
        SizedBox(height: 5,),
        Container(
          width: 100,
          height: 1,
          color: Colors.black54,
        ),
        SizedBox(height: 10),

        SingleChildScrollView(
          child: Container(
            color: Colors.greenAccent,
            height: 170,
            width: 250,
            child: StreamBuilder<QuerySnapshot>(
                stream: db.collection("software_issues").snapshots(),
                // ignore: missing_return
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("loading");
                  }
                  return ListView(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                       Center(
                         child: Text(document.data()['student query'],
                            style: TextStyle(
                              decorationStyle: TextDecorationStyle.double,
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),),
                       );
                    }).toList(),
                  );
                }
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF56ccf2),
        title: Text("Issues Available".toUpperCase()),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
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
        stream: db.collection("software_issues").snapshots(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("loading");
          }
          return ListView(
            padding: EdgeInsets.all(16),
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                height: 180,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                                "assets/images/imgplaceholder.png"),

                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 110,
                        color: Color(0xFF008ECC),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30, left: 10),
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
                            Text(document.data()['student number'],
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.double,
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 9,),
                            Text(document.data()['student phone']),
                            SizedBox(height: 9,),
                            Text(document.data()['student email']),
                            SizedBox(height: 6,),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFF008ECC),
                                borderRadius: BorderRadius.circular(10,)
                              ),
                              child: FlatButton(
                                onPressed: _displayIssueDialog,
                                child: Text("VIEW ISSUE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      // ListTile(
                      //   title: Text(document.data()['name']),
                      //   subtitle: Text(document.data()['student email']),
                      // ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
    ));


  }
}
