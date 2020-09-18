// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
//
// class HardwareIssuesContactForm extends StatefulWidget {
//   @override
//   _HardwareIssuesContactFormState createState() => _HardwareIssuesContactFormState();
// }
//
// class _HardwareIssuesContactFormState extends State<HardwareIssuesContactForm> {
//   String attachment;
//
//   final _recipientController = TextEditingController(
//     text: 'example@example.com',
//   );
//
//   final _subjectController = TextEditingController(text: 'The subject');
//
//   final _bodyController = TextEditingController(
//     text: 'Mail body.',
//   );
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   Future<void> send() async {
//     final Email email = Email(
//       body: _bodyController.text,
//       subject: _subjectController.text,
//       recipients: [_recipientController.text],
//       // attachmentPaths: attachment,
//     );
//
//     String platformResponse;
//
//     try {
//       await FlutterEmailSender.send(email);
//       platformResponse = 'success';
//     } catch (error) {
//       platformResponse = error.toString();
//     }
//
//     if (!mounted) return;
//
//     _scaffoldKey.currentState.showSnackBar(SnackBar(
//       content: Text(platformResponse),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Widget imagePath = Text(attachment ?? '');
//
//     return MaterialApp(
//       theme: ThemeData(primaryColor: Colors.red),
//       home: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text('Plugin example app'),
//           actions: <Widget>[
//             IconButton(
//               onPressed: send,
//               icon: Icon(Icons.send),
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _recipientController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Recipient',
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _subjectController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Subject',
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _bodyController,
//                       maxLines: 10,
//                       decoration: InputDecoration(
//                           labelText: 'Body', border: OutlineInputBorder()),
//                     ),
//                   ),
//                   imagePath,
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // ignore: missing_required_param
//         floatingActionButton: FloatingActionButton.extended(
//           icon: Icon(Icons.camera),
//           label: Text('Add Image'),
//           //onPressed: _openImagePicker,
//         ),
//       ),
//     );
//   }
//
//   // void _openImagePicker() async {
//   //   File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
//   //   setState(() {
//   //     attachment = pick.path;
//   //   });
//   // }
// }