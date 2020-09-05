import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_support/screen/dashboard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'contact.dart';

class SoftwareIssuesContactForm extends StatefulWidget {
  @override
  _SoftwareIssuesContactFormState createState() =>
      _SoftwareIssuesContactFormState();
}

class _SoftwareIssuesContactFormState extends State<SoftwareIssuesContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> _semesters = <String>['', 'Semester 1', 'Semester 2',
    'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7',
    'Semester 8'];

  String _stNumber;
  String _stEmail;
  String _query;
  String _dropdownError;
  String _stPhone;
  String _selectedItem;
  bool _autoValidate = false;

  String _semester = '';
  // Contact newContact = Contact();

  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController studentNumberController = TextEditingController();
  TextEditingController studentEmailController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController studentPhoneNumberController = TextEditingController();

  PageController _pageController;

  @override
  void dispose() {
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ######## FOR VALIDATING STUDENT NUMBER #######
   *********************************************************/
  String validateStudentNumber(String value){
    if (value.isEmpty) {
      return 'Student Number is required';
    }
    else {
      return null;
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ######## FOR VALIDATING PHONE NUMBER #######
   *********************************************************/
  String validateStudentPhoneNumber(String value){
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null) return 'Phone Number is required';
    // else if (value.length != 10) {
    //   return 'Phone Number must be of 10 digits';
    // }
    else if (!regExp.hasMatch(value)) {
      return 'Enter a valid Phone Number';
    }
    return null;
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ######## FOR VALIDATING EMAIL ADDRESS #######
   *********************************************************/

  String validateStudentEmailAddress (String value){
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
  /**********************************************************
          ######## FOR VALIDATING ENQUIRIES #######
   *********************************************************/
  String validateStudentQuery(String value){
    if (value.isEmpty) {
      return 'You forgot to state the problem...';
    }
    else {
      return null;
    }
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
  validateAndSubmit(){
    if (validateAndSave()) {
      try{
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => DashboardScreen()),
        // );

        /**********************************************************
                 ####### SHOW DIALOG ON SUBMIT ########
         ***********************************************************/
                 return showDialog(
                     barrierDismissible: false,
                     context: context,
                     builder: (BuildContext context){
                       return Dialog(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(50),
                         ),
                         elevation: 6,
                         backgroundColor: Colors.transparent,
                         child: _buildDialogContent(context),
                       );
                     }
                 );
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
    return Scaffold(
      backgroundColor: Color(0xFF56ccf2),
      // backgroundColor: Colors.grey[100],
      body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Container(
              // height: 600,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30,),
                    child: Text(
                      "IT SUPPORT QUERY FORM",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 5.0, left: 15.0, right: 15.0),
                    child: Card(
                      elevation: 6,
                      child: Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: ListView(
                            shrinkWrap: true, // use this
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            children: <Widget>[
                              //===> Email Number Text Input starts from here <===
                              Padding(
                                padding: EdgeInsets.only(
                              top: 10.0, bottom: 6.0, left: 1.0, right: 1.0),
                                child: TextFormField(
                                  autofocus: false,
                                  focusNode: myFocusNodeEmail,
                                  controller: studentNumberController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    // icon: Icon(Icons.person),
                                    // hintText: 'Enter your first and last name',
                                    labelText: 'Student Number',
                                  ),
                                  validator: validateStudentNumber,
                                  onSaved: (String val) {
                                    _stNumber = val;
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       top: 5.0, bottom: 10.0, left: 1.0, right: 1.0),
                              //   child: TextFormField(
                              //     decoration: InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(20.0),
                              //       ),
                              //       // icon: const Icon(Icons.phone),
                              //       // hintText: 'Enter a phone number',
                              //       labelText: 'Phone',
                              //     ),
                              //     keyboardType: TextInputType.phone,
                              //     inputFormatters: [
                              //       WhitelistingTextInputFormatter.digitsOnly,
                              //     ],
                              //   ),
                              // ),

                              //===> Email Address Text Input starts from here <===
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1.0, bottom: 6.0, left: 1.0, right: 1.0),
                                child: TextFormField(
                                  validator: validateStudentEmailAddress,
                                  onSaved: (String val) {
                                    _stEmail = val;
                                  },
                                  controller: studentEmailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    // icon: const Icon(Icons.email),
                                    // hintText: 'Enter a email address',
                                    labelText: 'Student Email',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black),
                                ),
                              ),

                              //===> Phone Number Text Input starts from here <===
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 1.0, bottom: 6.0, left: 1.0, right: 1.0),
                                child: TextFormField(
                                  validator: validateStudentPhoneNumber,
                                  onSaved: (String val) {
                                    _stPhone = val;
                                  },
                                  controller: studentPhoneNumberController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    // icon: const Icon(Icons.email),
                                    // hintText: 'Enter a email address',
                                    labelText: 'Phone Number',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[()\d -]{1,15}$')),
                                  ],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black),
                                ),
                              ),

                              //===> Drop Down Menu starts from here <===
                              Padding(
                                padding: EdgeInsets.only(top: 1.0, bottom: 6.0, left: 1.0, right: 1.0),
                                child: FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        // icon: const Icon(Icons.color_lens),
                                        labelText: 'Semester',
                                        hintText: ("Semester"),
                                      ),
                                      isEmpty: _semester == '',
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 1.0, right: 130 , ),
                                        child: Container(
                                          // height: 55,  //gives the height of the dropdown button
                                          width: MediaQuery.of(context).size.width,
                                          child: DropdownButtonHideUnderline( // to hide the default underline of the dropdown button
                                            child: ButtonTheme(
                                              alignedDropdown: true, //If false (the default), then the dropdown's menu will be wider than its button.
                                              child: DropdownButton(
                                                value: _semester,
                                                isDense: true,
                                                elevation: 5,
                                                isExpanded: true,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    _semester = value; // saving the selected value
                                                    state.didChange(value);
                                                  });
                                                },
                                                items: _semesters.map((String value) {
                                                  return DropdownMenuItem(
                                                    value: value,  // displaying the selected value
                                                    child: Text(value ?? '',
                                                        textAlign: TextAlign.left,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              //===> Query Text Input starts from here <===
                              TextFormField(
                                validator: validateStudentQuery,
                                onSaved: (String val) {
                                  _query = val;
                                },
                                controller: queryController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  // icon: const Icon(Icons.email),
                                  // hintText: 'Enter your query',
                                  labelText: 'Your Query',
                                ),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black),
                                maxLines: 3,
                              ),

                              // ignore: slash_for_doc_comments
                              /**********************************************************
                                        ####### FOR SUBMIT BUTTON ########
                               ***********************************************************/

                              Container(
                                  // padding: EdgeInsets.only(left: 1.0, top: 10.0),
                                  margin: EdgeInsets.only(top: 6.0, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                          Color(0xFF008ECC), //Colors is Olympic blue
                                          Color(0xFF008ECC),
                                        ],
                                        begin: FractionalOffset(0.2, 0.2),
                                        end: FractionalOffset(1.0, 1.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  child: MaterialButton(
                                    onPressed: validateAndSubmit,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 65.0),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

// ignore: slash_for_doc_comments
/**********************************************************
    ### IMPLEMENTATION OF _buildDialogContent METHOD ###
 ***********************************************************/

Widget _buildDialogContent(BuildContext context) => Container(
  height: 230,
  decoration: BoxDecoration(
    color: Color(0xFF008ECC),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  child: Column(
    children: <Widget>[
      Container(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Container(
            height: 80, width: 80,
            child: Icon(MdiIcons.vote,
              size: 90,
              color: Color(0xFF56ccf2),
            ),
          ),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12),
              topRight: Radius.circular(12)),
        ),
      ),
      SizedBox(height: 24),
      Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Text("To submit the form tap Yes. tap No to edit the form".toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
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
            child: Text("No".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    Color(0xFF008ECC), //Colors is Olympic blue
                    Color(0xFF008ECC),
                  ],
                  begin: FractionalOffset(0.2, 0.2),
                  end: FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: RaisedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              color: Colors.white,
              child: Text("Yes".toUpperCase(),
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);