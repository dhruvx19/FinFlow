import 'package:FinFlow/views/homepage.dart';
import 'package:FinFlow/views/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class AuthService {
  static const String authBoxName = 'authBox';
  static const String userEmailKey = 'userEmail';
  late Box _authBox;

  Future<void> initAuthBox() async {
    _authBox = await Hive.openBox(authBoxName);
  }

  Future<void> signup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await initAuthBox();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await _authBox.put(userEmailKey, email);
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeView()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      _showToast(message);
    }
  }

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await initAuthBox();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _authBox.put(userEmailKey, email);
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeView()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      _showToast(message);
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await initAuthBox();
    await FirebaseAuth.instance.signOut();
    await _authBox.clear();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  Future<bool> isUserLoggedIn() async {
    await initAuthBox();
    final userEmail = _authBox.get(userEmailKey);
    return userEmail != null && userEmail.isNotEmpty;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
