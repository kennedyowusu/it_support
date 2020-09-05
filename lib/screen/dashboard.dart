import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'screens.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // TextEditingController _textFieldController = TextEditingController();

  File _pickedImage;

  _loadPicker(ImageSource source) async {
    File picked = await ImagePicker.pickImage(source: source);
    if (picked != null) {
      _cropImage(picked);
    }
    Navigator.pop(context);
  }

  _cropImage(File picked) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.red,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
      });
    }
  }


  // ignore: slash_for_doc_comments
  /*********************************************************************
      ####### FOR PICKING IMAGE EITHER FROM GALLERY OF CAMERA ######
   *********************************************************************/
  // void _showPickOptionsDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) =>
  //         AlertDialog(
  //           title: Text("Choose Image from..."),
  //           content: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               ListTile(
  //                 title: Text("Gallery"),
  //                 onTap: () {
  //                   // _loadPicker(ImageSource.gallery);
  //                 },
  //               ),
  //               ListTile(
  //                 title: Text("Camera"),
  //                 onTap: () {
  //                   // _loadPicker(ImageSource.camera);
  //                 },
  //               )
  //             ],
  //           ),
  //         ),
  //   );
  // }

  _showPickOptionsDialog() {
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
            child: _buildImgPickerDialogContent(context),
          );
        });
  }

  // ignore: slash_for_doc_comments
  /*********************************************************************
      ####### FOR _buildImgPickerDialogContent ######
   *********************************************************************/
  Widget _buildImgPickerDialogContent(BuildContext context) => Container(
    height: 120,
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
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 60),
              child: Text(
                "CHOOSE IMAGE FROM...".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
              child: Text(
                "Camera",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                _loadPicker(ImageSource.camera);
              },
            ),
            SizedBox(width: 8),
            RaisedButton(
              color: Colors.white,
              child: Text(
                "GALLERY".toUpperCase(),
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () {
                _loadPicker(ImageSource.gallery);
                // print('Update the user info');
                // return Navigator.of(context).pop(true);
              },
            )
          ],
        ),
      ],
    ),
  );



  // ignore: slash_for_doc_comments
  /*********************************************************************
            ################# FOR UPDATING USER DATA ##################
   *********************************************************************/
  _displayDialog() {
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
            child: _buildUpdateDialogContent(context),
          );
        });
  }

  // ignore: slash_for_doc_comments
  /*********************************************************************
      ####### FOR _buildUpdateDialogContent ######
   *********************************************************************/

  Widget _buildUpdateDialogContent(BuildContext context) => Container(
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    "UPDATE YOUR INFO".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                      onTap: () {
                        _showPickOptionsDialog();
                      },
                      child: Icon(
                    Icons.add_a_photo,
                    color: Color(0xFF778899),
                  )),
                )
              ],
            ),
            SizedBox(height: 10),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )),
            Container(
              width: 150.0,
              height: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Semester',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Update".toUpperCase(),
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    print('Update the user info');
                    // return Navigator.of(context).pop(true);
                  },
                )
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFF56ccf2),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 64,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                            width: 70,
                            // margin: EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  // backgroundColor: Color(0xFF778899),
                                  backgroundColor: Colors.white,
                                  child: _pickedImage == null ? Image.asset("assets/images/imgplaceholder.png") : null,
                                  backgroundImage:
                                  _pickedImage != null ? FileImage(_pickedImage) : null,
                                  // backgroundImage: AssetImage(
                                  //     "assets/images/imgplaceholder.png"),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 30,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      // color: Color(0xFF56ccf2),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: _displayDialog,
                                      child: Icon(
                                        MdiIcons.pen,
                                        size: 15,
                                        color: Color(0xFF56ccf2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Fredrick Morrison",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Semester 5",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  )),

                              // Padding(
                              //   padding: EdgeInsets.only(left: 190),
                              //   child: Text("Logout",
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 13,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 80,
                            child: Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Icon(
                                  MdiIcons.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => HardwareIssuesContactForm()),
                              // );
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
                                    builder: (context) => AdminDashboard()),
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
                                        DialogWithTextField()),
                              );
                            },
                            title: "Internet Connectivity",
                            icon: IconData(0xe900, fontFamily: 'internet'),
                            // color: Color(0xFF56ccf2),
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                          CardHolder(
                            onTap: () {},
                            title: "App/Web Development",
                            icon: IconData(0xe900, fontFamily: 'app'),
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                          CardHolder(
                            onTap: () {},
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
