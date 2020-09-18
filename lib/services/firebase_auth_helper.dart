import 'package:firebase_auth/firebase_auth.dart';
import 'package:it_support/enum/auth_result_status.dart';

import 'auth_exception_handler.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;

  /// Helper Functions

  Future<AuthResultStatus> createAccount({email, password}) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> login({email, password}) async {
    try {
      final authResult =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  logout() {
    _auth.signOut();
  }
}