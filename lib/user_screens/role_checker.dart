// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:it_support/admin/admin_dashboard.dart';
// import 'package:it_support/services/authhelper.dart';
// import 'package:it_support/widget/spinkit.dart';
// import 'dashboard.dart';
// import 'login.dart';
//
// class RoleChecker extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             UserHelper.saveUser(snapshot.data);
//             return StreamBuilder<DocumentSnapshot>(DocumentSnapshot
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .doc(snapshot.data.uid)
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasData && snapshot.data != null) {
//                   final userDoc = snapshot.data;
//                   final user = userDoc.data();
//                   print(user['role']);
//                   return (user['role'] == 'admin')
//                       ? AdminDashboard()
//                       : DashboardScreen();
//                 } else {
//                   return Material(
//                     child: Center(
//                       child: spinkit,
//                     ),
//                   );
//                 }
//               },
//             );
//           }
//           return LoginScreen();
//         });
//   }
// }