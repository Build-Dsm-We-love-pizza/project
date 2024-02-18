import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () async {
            log(await FireAuth.getIdToken());
          },
          child: Text('ID Tok')),
    ));
  }
}
