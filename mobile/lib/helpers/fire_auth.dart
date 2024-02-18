// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/custom_snackbar.dart';

class FireAuth {
  static Future<String> getIdToken() async {
    String? tok = await FirebaseAuth.instance.currentUser!.getIdToken();

    return tok!;
  }

  static signout() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut();
  }

  static String getUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<User?> loginWithEmailPass(
      {required String email,
      required String password,
      required BuildContext ctx}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
      UserCredential cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = cred.user;

      await user!.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {}
      ctx.showErrorSnackBar("Invalid Credentials");
    }
    return user;
  }

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }
}
