import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        // ElevatedButton(
        //     onPressed: () async {
        //       print(await FireAuth.getIdToken());
        //     },
        //     child: Text('ID Tok')),
        Text(FirebaseAuth.instance.currentUser!.email!),
        ElevatedButton(
            onPressed: () async {
              log(await FireAuth.signout());
            },
            child: Text('Sign out')),
      ],
    )));
  }
}
