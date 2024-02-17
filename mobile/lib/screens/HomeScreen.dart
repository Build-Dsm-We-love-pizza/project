import 'package:flutter/material.dart';
import 'package:mobile/helpers/fire_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          TextButton(
              onPressed: () {
                FireAuth.signout();
              },
              child: const Text('Sign out'))
        ],
      ),
    ));
  }
}
