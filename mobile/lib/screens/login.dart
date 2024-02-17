// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile/screens/HomeScreen.dart';
// import 'package:login_app/components/components.dart';
// import 'package:login_app/constants.dart';
// import 'package:login_app/screens/welcome.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:login_app/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            TextField(),
          ],
        ),
      ),
    );
  }
}
