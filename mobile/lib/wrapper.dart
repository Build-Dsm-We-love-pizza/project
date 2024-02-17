import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/HomeScreen.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          // return const ErrorPage(); // You should handle errors appropriately
          log(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data != null && snapshot.data!.uid.isNotEmpty) {
          print('UID: ---------  ${snapshot.data!.uid}');
          return const HomeScreen();
        } else {
          return const MyHomePage();
        }
      },
    );

    // return FutureBuilder(
    //     future: _initialization,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         // return ErrorPage();
    //         log(snapshot.error.toString());
    //       }

    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return MyHomePage();
    //       }

    //       // return LoadingPage();
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });
  }
}
