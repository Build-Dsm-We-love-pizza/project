import 'package:flutter/material.dart';
import 'package:mobile/screens/HomeScreen.dart';
import 'package:mobile/screens/Signup.dart';
import 'package:mobile/screens/login.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/home': (_) => const HomeScreen(),
  '/login': (_) => const LoginScreen(),
  '/signup': (_) => const SignupScreen(),
};
