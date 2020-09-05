import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

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

  Widget _buildViewIssueDialogContent(BuildContext context) => Container(
    height: 280,
    decoration: BoxDecoration(
      color:  Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: SingleChildScrollView(
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
          SizedBox(height: 10),

          Row(
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
              SizedBox(height: 358),
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
        ],
      ),
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
      body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
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
                    // SizedBox(
                    //   width: 1,
                    // ),
                      Padding(
                        padding: EdgeInsets.only(top: 30,),
                        child: Container(
                          width: 150,
                          child: Column(
                            children: [
                              // SizedBox(height: 5,),
                              Text("STUDENT NUMBER"),
                              SizedBox(height: 10,),
                              Text("STUDENT EMAIL"),
                              SizedBox(height: 10,),
                              Text("PHONE NUMBER"),
                              SizedBox(height: 5,),
                              RaisedButton(
                                color: Color(0xFF008ECC),
                                  onPressed: _displayIssueDialog,
                                  child: Text("VIEW ISSUE",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
